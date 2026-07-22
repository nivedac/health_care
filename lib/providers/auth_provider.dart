import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';
import '../core/error_handler.dart';

/// Manages the authentication state of the application.
///
/// This provider serves as the bridge between the UI and the [AuthRepository].
/// It handles the state of the current user, loading states during authentication
/// operations, and triggers notifications to listeners when the state changes.
///
/// AUTHENTICATION FLOWS:
/// - Patient: Phone Number OTP (`login` → `verifyOtp`)
/// - Admin/Receptionist: Email + Password (`loginWithEmailPassword`)
class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;

  AuthProvider({AuthRepository? repository})
      : _repository = repository ?? AuthRepository();

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _phoneNumber;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;
  String? get phoneNumber => _phoneNumber;

  // ---------------------------------------------------------------------------
  // Patient — Phone OTP Flow
  // ---------------------------------------------------------------------------

  /// Initiates the phone number authentication flow (Patient only).
  ///
  /// Triggers an OTP SMS to [phone]. On success, the OTP screen calls
  /// [verifyOtp] to complete sign-in.
  ///
  /// Returns `true` if OTP was dispatched successfully.
  Future<bool> login(String phone, String dummyPassword) async {
    _isLoading = true;
    _phoneNumber = phone;
    notifyListeners();
    try {
      await _repository.requestOtp(
        phone,
        (verificationId) {
          debugPrint('OTP code sent. verificationId received.');
        },
        (error) {
          ErrorHandler.handleError(error);
        },
      );
      return true;
    } catch (e, stackTrace) {
      ErrorHandler.handleError(e, stackTrace: stackTrace);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Verifies the OTP entered by the patient.
  ///
  /// On success, sets [currentUser] and notifies listeners. The role-based
  /// router will then redirect to `/patient`.
  Future<bool> verifyOtp(String otp) async {
    _isLoading = true;
    notifyListeners();
    try {
      _currentUser = await _repository.verifyOtp(otp);
      return true;
    } catch (e, stackTrace) {
      ErrorHandler.handleError(e, stackTrace: stackTrace);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ---------------------------------------------------------------------------
  // Admin / Receptionist — Email + Password Flow
  // ---------------------------------------------------------------------------

  /// Signs in a staff member (admin or receptionist) using email and password.
  ///
  /// SECURITY: The role is read from Firestore after sign-in.
  /// A patient account will be blocked from accessing the staff portal.
  /// Returns `true` on success; shows an error snackbar on failure.
  Future<bool> loginWithEmailPassword(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      _currentUser = await _repository.loginWithEmailPassword(email, password);
      return true;
    } catch (e, stackTrace) {
      ErrorHandler.handleError(e, stackTrace: stackTrace);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ---------------------------------------------------------------------------
  // Shared
  // ---------------------------------------------------------------------------

  /// Attempts to restore the current authenticated session on app start.
  ///
  /// Called during the splash screen to check if a user is already signed in.
  /// Returns `true` if a valid session was restored.
  Future<bool> restoreSession() async {
    _isLoading = true;
    notifyListeners();
    try {
      _currentUser = await _repository.getCurrentUser();
      return _currentUser != null;
    } catch (e) {
      _currentUser = null;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    await _repository.logout();
    _currentUser = null;
    _phoneNumber = null;
    _isLoading = false;
    notifyListeners();
  }
}
