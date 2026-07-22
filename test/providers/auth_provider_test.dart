import 'package:flutter_test/flutter_test.dart';
import 'package:baijus/providers/auth_provider.dart';
import 'package:baijus/models/user_model.dart';
import 'package:baijus/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;

/// Mock AuthRepository for unit testing AuthProvider in isolation.
/// 
/// This mock simulates both patient phone OTP flow and staff email/password flow
/// without making real Firebase network calls.
class MockAuthRepository implements AuthRepository {
  @override
  Future<UserModel> login(String phone, String password) async {
    throw UnimplementedError('Use requestOtp + verifyOtp instead');
  }

  @override
  Future<void> logout() async {}

  @override
  Future<UserModel?> getCurrentUser() async {
    return null;
  }

  @override
  Future<void> requestOtp(
    String phoneNumber,
    Function(String) codeSent,
    Function(FirebaseAuthException) verificationFailed,
  ) async {
    codeSent('dummy_verification_id');
  }

  @override
  Future<UserModel> verifyOtp(String otp) async {
    return const UserModel(
      id: 'test_uid_patient',
      name: 'Test Patient',
      email: '',
      phoneNumber: '+919876543210',
      role: 'patient',
    );
  }

  @override
  Future<UserModel> loginWithEmailPassword(
    String email,
    String password,
  ) async {
    if (email == 'admin@drbaijus.com' && password == 'testpass') {
      return const UserModel(
        id: 'test_uid_admin',
        name: 'Test Admin',
        email: 'admin@drbaijus.com',
        role: 'admin',
      );
    }
    if (email == 'patient@test.com') {
      throw Exception('Access denied. This login is only for clinic staff.');
    }
    throw Exception('Invalid credentials');
  }
}

void main() {
  // Required because ErrorHandler uses a GlobalKey<ScaffoldMessengerState>
  // which needs the widget binding initialized, even in unit tests.
  TestWidgetsFlutterBinding.ensureInitialized();

  late AuthProvider authProvider;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    authProvider = AuthProvider(repository: mockAuthRepository);
  });

  group('AuthProvider — Initial State', () {
    test('initial state is correct', () {
      expect(authProvider.isLoading, isFalse);
      expect(authProvider.currentUser, isNull);
      expect(authProvider.isAuthenticated, isFalse);
    });
  });

  group('AuthProvider — Patient Phone OTP Flow', () {
    test('login triggers OTP and returns true on success', () async {
      final result = await authProvider.login('+919876543210', '');
      expect(result, isTrue);
      // OTP was requested; user is not yet authenticated
      expect(authProvider.isAuthenticated, isFalse);
    });

    test('verifyOtp authenticates the patient successfully', () async {
      await authProvider.login('+919876543210', '');
      final result = await authProvider.verifyOtp('123456');

      expect(result, isTrue);
      expect(authProvider.isAuthenticated, isTrue);
      expect(authProvider.currentUser?.role, equals('patient'));
      expect(authProvider.currentUser?.phoneNumber, equals('+919876543210'));
      expect(authProvider.isLoading, isFalse);
    });

    test('logout clears patient state', () async {
      await authProvider.login('+919876543210', '');
      await authProvider.verifyOtp('123456');
      expect(authProvider.isAuthenticated, isTrue);

      await authProvider.logout();

      expect(authProvider.currentUser, isNull);
      expect(authProvider.isAuthenticated, isFalse);
      expect(authProvider.phoneNumber, isNull);
    });
  });

  group('AuthProvider — Staff Email/Password Flow', () {
    test('admin login succeeds with correct credentials', () async {
      final result = await authProvider.loginWithEmailPassword(
        'admin@drbaijus.com',
        'testpass',
      );

      expect(result, isTrue);
      expect(authProvider.isAuthenticated, isTrue);
      expect(authProvider.currentUser?.role, equals('admin'));
      expect(authProvider.isLoading, isFalse);
    });

    test('staff login fails when patient email is used', () async {
      final result = await authProvider.loginWithEmailPassword(
        'patient@test.com',
        'anypass',
      );

      expect(result, isFalse);
      expect(authProvider.isAuthenticated, isFalse);
    });

    test('staff login fails with wrong credentials', () async {
      final result = await authProvider.loginWithEmailPassword(
        'admin@drbaijus.com',
        'wrongpass',
      );

      expect(result, isFalse);
      expect(authProvider.isAuthenticated, isFalse);
    });
  });

  group('AuthProvider — Role Security', () {
    test('patient role cannot be elevated through login', () async {
      await authProvider.login('+919876543210', '');
      await authProvider.verifyOtp('123456');

      // A patient who signs in via phone must always have role 'patient'
      expect(authProvider.currentUser?.role, equals('patient'));
    });
  });
}
