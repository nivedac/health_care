import '../models/user_model.dart';

class AuthRepository {
  Future<UserModel> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Mock network delay
    // Mock user login
    if (email.contains('admin')) {
      return const UserModel(id: 'u1', name: 'Admin User', email: 'admin@clinic.com', role: 'admin');
    } else if (email.contains('reception')) {
      return const UserModel(id: 'u2', name: 'Receptionist Sarah', email: 'sarah@clinic.com', role: 'reception');
    } else if (email.contains('doctor')) {
      return const UserModel(id: 'u3', name: 'Dr. Baiju', email: 'doctor@clinic.com', role: 'doctor');
    }
    return UserModel(id: 'u4', name: 'Patient John', email: email, role: 'patient');
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<UserModel?> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return null; // By default, no one is logged in for mock
  }
}
