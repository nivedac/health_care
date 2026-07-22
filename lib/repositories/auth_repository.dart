import '../models/user_model.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Repository that handles all Firebase Authentication operations.
///
/// ARCHITECTURE:
/// - Patients authenticate via Firebase Phone Number OTP.
/// - Admin and Receptionist authenticate via Firebase Email + Password.
///
/// ROLE SECURITY:
/// - Roles are NEVER accepted from the client at login time.
/// - Roles are read exclusively from trusted Firestore `users/{uid}` documents.
/// - New patient registration hardcodes `role: 'patient'` server-side.
/// - Admin/Receptionist accounts must be pre-created by an admin — 
///   they cannot self-register through the patient app.
class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _verificationId;

  // ---------------------------------------------------------------------------
  // PATIENT — Phone OTP Authentication
  // ---------------------------------------------------------------------------

  /// Triggers the Firebase Phone OTP flow.
  ///
  /// [phoneNumber] must be in E.164 format (e.g., +919876543210).
  /// [codeSent] is called with the [verificationId] when the SMS is sent.
  /// [verificationFailed] is called if Firebase rejects the request.
  Future<void> requestOtp(
    String phoneNumber,
    Function(String) codeSent,
    Function(FirebaseAuthException) verificationFailed,
  ) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-resolution on Android (SMS retrieved automatically).
        // We do NOT auto-sign in here — we let the OTP screen handle it
        // so the user is always aware authentication is happening.
        debugPrint('Auto-resolved phone credential (not auto-signing in).');
      },
      verificationFailed: verificationFailed,
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        codeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  /// Verifies the OTP entered by the patient and signs them in.
  ///
  /// On success, creates or retrieves the Firestore user record
  /// and persists the FCM device token.
  Future<UserModel> verifyOtp(String otp) async {
    if (_verificationId == null) {
      throw Exception(
        'No verification ID available. Please request a new OTP.',
      );
    }
    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: otp,
    );
    final userCredential = await _auth.signInWithCredential(credential);
    final user = await _fetchOrCreatePatientRecord(userCredential.user!);
    await _persistFcmToken(userCredential.user!.uid);
    return user;
  }

  // ---------------------------------------------------------------------------
  // ADMIN / RECEPTIONIST — Email + Password Authentication
  // ---------------------------------------------------------------------------

  /// Signs in an admin or receptionist using Firebase Email + Password.
  ///
  /// SECURITY: The role is read from Firestore AFTER sign-in.
  /// The client cannot pass a role — it is always sourced from the
  /// trusted `users/{uid}` document in Firestore.
  ///
  /// Throws [FirebaseAuthException] if credentials are invalid.
  /// Throws [Exception] if the user has no staff role in Firestore
  /// (i.e., a patient UID is blocked from accessing staff login).
  Future<UserModel> loginWithEmailPassword(
    String email,
    String password,
  ) async {
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final firestoreUser = await _fetchUserFromFirestore(userCredential.user!);

    // Enforce staff-only access through this login path.
    // A patient account must NOT be able to log in via the admin/reception portal.
    if (firestoreUser.role != 'admin' && firestoreUser.role != 'reception') {
      await _auth.signOut(); // Revoke the session immediately.
      throw Exception(
        'Access denied. This login is only for clinic staff.',
      );
    }

    await _persistFcmToken(userCredential.user!.uid);
    return firestoreUser;
  }

  // ---------------------------------------------------------------------------
  // SHARED
  // ---------------------------------------------------------------------------

  /// Returns the currently signed-in user from Firestore, or null.
  Future<UserModel?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        return await _fetchUserFromFirestore(user);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  // ---------------------------------------------------------------------------
  // PRIVATE HELPERS
  // ---------------------------------------------------------------------------

  /// Fetches the Firestore `users/{uid}` document.
  ///
  /// Throws if the document does not exist (staff must be pre-created).
  Future<UserModel> _fetchUserFromFirestore(User user) async {
    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) {
      throw Exception(
        'User record not found in Firestore. '
        'Staff accounts must be created by an administrator.',
      );
    }
    return UserModel.fromJson({...doc.data()!, 'id': doc.id});
  }

  /// Fetches or creates a Firestore `users/{uid}` document for a new patient.
  ///
  /// ROLE SECURITY: New users are always created with `role: 'patient'`.
  /// The client cannot override this. No role is accepted from user input.
  Future<UserModel> _fetchOrCreatePatientRecord(User user) async {
    final docRef = _firestore.collection('users').doc(user.uid);
    final doc = await docRef.get();

    if (doc.exists) {
      return UserModel.fromJson({...doc.data()!, 'id': doc.id});
    }

    // First-time patient login: create a minimal record.
    // Role is hardcoded to 'patient'. This is also enforced by Firestore
    // security rules (patients cannot write their own role field).
    final newUser = UserModel(
      id: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
      role: 'patient', // Always 'patient' — never from client input.
      phoneNumber: user.phoneNumber,
    );

    await docRef.set({
      ...newUser.toJson(),
      'createdAt': FieldValue.serverTimestamp(),
    });

    return newUser;
  }

  /// Stores or refreshes the FCM device token in the user's Firestore document.
  ///
  /// This enables server-side (Cloud Functions) to send targeted push
  /// notifications to a specific device. The token is stored under
  /// `users/{uid}` and must be refreshed on each login.
  Future<void> _persistFcmToken(String uid) async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await _firestore.collection('users').doc(uid).update({
          'fcmToken': token,
          'lastLoginAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      // Non-fatal: FCM token persistence failure should not block login.
      debugPrint('FCM token persistence failed: $e');
    }
  }

  // Legacy interface — kept for backward compatibility with existing code.
  // Use requestOtp + verifyOtp instead.
  Future<UserModel> login(String phone, String dummy) async {
    throw UnimplementedError(
      'Use requestOtp() and verifyOtp() for patient phone auth, '
      'or loginWithEmailPassword() for staff auth.',
    );
  }
}
