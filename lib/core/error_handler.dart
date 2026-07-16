import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'app_exceptions.dart';

class ErrorHandler {
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

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
      case 'invalid-email':
        return 'The email address is badly formatted.';
      case 'user-disabled':
        return 'This user has been disabled.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided for that user.';
      case 'email-already-in-use':
        return 'The email address is already in use by another account.';
      case 'operation-not-allowed':
        return 'Operation not allowed. Please contact support.';
      case 'weak-password':
        return 'The password provided is too weak.';
      default:
        return e.message ?? 'Authentication failed.';
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
