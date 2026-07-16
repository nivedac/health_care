import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';
import '../core/error_handler.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();
  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;

  // We keep `login` for compatibility, but it now acts as a trigger to start phone auth
  Future<bool> login(String phone, String dummyPassword) async {
    _isLoading = true;
    _phoneNumber = phone;
    notifyListeners();
    try {
      // In real implementation we'd wait for codeSent to return true,
      // but to keep the flow we just return true and let OTP screen handle verification.
      await _repository.requestOtp(
        phone,
        (verificationId) {
          _pendingVerificationId = verificationId;
          debugPrint('Code sent: $verificationId');
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

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    await _repository.logout();
    _currentUser = null;
    _isLoading = false;
    notifyListeners();
  }
}

