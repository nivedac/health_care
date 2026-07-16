import '../models/user_model.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _verificationId;

  // Since we need to keep the existing interface `login`, we'll use it to trigger OTP request.
  // The 'password' argument will be ignored or used as dummy.
  // Real implementation for Phone Auth requires callbacks.
  Future<UserModel> login(String phone, String dummy) async {
    // This is just a placeholder to satisfy the interface.
    // In a real app we need to use verifyPhoneNumber.
    throw UnimplementedError('Use requestOtp and verifyOtp instead for Phone Auth');
  }

  Future<void> requestOtp(String phoneNumber, Function(String) codeSent, Function(FirebaseAuthException) verificationFailed) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-resolution
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

  Future<UserModel> verifyOtp(String otp) async {
    if (_verificationId == null) throw Exception('No verification ID');
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: otp,
    );
    UserCredential userCredential = await _auth.signInWithCredential(credential);
    return await _fetchUserFromFirestore(userCredential.user!);
  }

  Future<UserModel> _fetchUserFromFirestore(User user) async {
    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (doc.exists) {
      return UserModel.fromJson({...doc.data()!, 'id': doc.id});
    }
    // If not exists, create a default patient role
    final newUser = UserModel(
      id: user.uid,
      name: user.displayName ?? 'New User',
      email: user.email ?? '',
      role: 'patient',
      phoneNumber: user.phoneNumber,
    );
    await _firestore.collection('users').doc(user.uid).set(newUser.toJson());
    return newUser;
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<UserModel?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      return await _fetchUserFromFirestore(user);
    }
    return null;
  }
}

