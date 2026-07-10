import '../models/employee_model.dart';

class EmployeeRepository {
  final List<EmployeeModel> _mockEmployees = [
    const EmployeeModel(id: 'e1', userId: 'u2', name: 'Sarah Jenkins', position: 'Receptionist', department: 'Front Desk'),
    const EmployeeModel(id: 'e2', userId: 'u1', name: 'Admin User', position: 'Administrator', department: 'Management'),
    const EmployeeModel(id: 'e3', userId: 'u8', name: 'Jane Doe', position: 'Nurse', department: 'Nursing'),
  ];

  Future<List<EmployeeModel>> getEmployees() async {
    await Future.delayed(const Duration(seconds: 1));
    return _mockEmployees;
  }

  Future<EmployeeModel?> getEmployeeById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      return _mockEmployees.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }
}
