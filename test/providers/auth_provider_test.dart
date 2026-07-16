import 'package:flutter_test/flutter_test.dart';
import 'package:baijus/providers/auth_provider.dart';
import 'package:baijus/models/user_model.dart';
import 'package:baijus/providers/auth_provider.dart';
import 'package:baijus/models/user_model.dart';
import 'package:baijus/repositories/auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  @override
  Future<UserModel> login(String phone, String password) async {
    return UserModel(
      id: '123',
      name: 'John Doe',
      phoneNumber: phone,
      role: UserRole.patient,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<void> logout() async {}
  
  @override
  Future<UserModel> registerPatient(UserModel user, String password) async {
    return user;
  }
}

void main() {
  late AuthProvider authProvider;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    authProvider = AuthProvider(repository: mockAuthRepository);
  });

  group('AuthProvider Tests', () {
    test('initial state is correct', () {
      expect(authProvider.isLoading, isFalse);
      expect(authProvider.currentUser, isNull);
      expect(authProvider.isAuthenticated, isFalse);
    });

    test('login sets user on success', () async {
      await authProvider.login('9876543210', 'password');

      expect(authProvider.currentUser?.phoneNumber, equals('9876543210'));
      expect(authProvider.isAuthenticated, isTrue);
      expect(authProvider.isLoading, isFalse);
    });
    
    test('logout clears user state', () async {
      await authProvider.login('9876543210', 'password');
      expect(authProvider.isAuthenticated, isTrue);

      await authProvider.logout();
      
      expect(authProvider.currentUser, isNull);
      expect(authProvider.isAuthenticated, isFalse);
    });
  });
}

