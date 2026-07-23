import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'app_exceptions.dart';

/// A centralized utility for handling and displaying application errors.
///
/// `ErrorHandler` intercepts exceptions from various layers of the app
/// (e.g., Firebase Authentication, Firestore, custom application logic)
/// and translates them into user-friendly error messages displayed via a [SnackBar].
class ErrorHandler {
  /// Global key required to access the [ScaffoldMessengerState] from anywhere
  /// in the app without requiring a [BuildContext].
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  /// Main entry point for error handling.
  ///
  /// Takes a [dynamic] error object and attempts to parse it into a readable
  /// string. Optionally accepts a [customMessage] to override the default parsing
  /// and a [stackTrace] for debugging purposes.
  static void handleError(dynamic error, {String? customMessage, StackTrace? stackTrace}) {
    String message = 'An unexpected error occurred.';

    if (error is AppException) {
      message = error.toString();
    } else if (error is FirebaseAuthException) {
      message = _handleFirebaseAuthError(error);
    } else if (error is FirebaseException) {
      message = _handleFirebaseError(error);
    } else if (error is Exception) {
      message = error.toString();
    } else if (error is String) {
      message = error;
    }

    if (customMessage != null) {
      message = customMessage;
    }

    debugPrint('ErrorHandler caught: $error\n$stackTrace');

    _showSnackBar(message);
  }

  static String _handleFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      // Email/Password errors
      case 'invalid-email':
        return 'The email address is badly formatted.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'user-not-found':
        return 'No account found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'operation-not-allowed':
        return 'Phone sign-in is currently unavailable. Please contact the clinic.';
      case 'weak-password':
        return 'Password is too weak. Please use a stronger password.';
      // Phone Auth errors
      case 'invalid-phone-number':
        return 'Invalid phone number. Please enter a valid number with country code.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait a few minutes and try again.';
      case 'session-expired':
        return 'OTP has expired. Please request a new code.';
      case 'invalid-verification-code':
        return 'Invalid OTP code. Please check and try again.';
      case 'missing-phone-number':
        return 'Please enter your phone number.';
      case 'quota-exceeded':
        return 'SMS quota exceeded. Please try again later.';
      // Network
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      default:
        return e.message ?? 'Authentication failed. Please try again.';
    }
  }

  static String _handleFirebaseError(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return 'You do not have permission to perform this action.';
      case 'unavailable':
        return 'Service is currently unavailable. Please check your internet connection.';
      case 'not-found':
        return 'The requested resource was not found.';
      case 'already-exists':
        return 'The resource already exists.';
      default:
        return e.message ?? 'A database error occurred.';
    }
  }

  static void _showSnackBar(String message) {
    if (scaffoldMessengerKey.currentState != null) {
      scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text(message, style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }
}
