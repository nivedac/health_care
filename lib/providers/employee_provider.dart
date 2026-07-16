import 'package:flutter/material.dart';
import '../models/employee_model.dart';
import '../repositories/employee_repository.dart';

class EmployeeProvider extends ChangeNotifier {
  final EmployeeRepository _repository = EmployeeRepository();
  List<EmployeeModel> _employees = [];
  bool _isLoading = false;

  List<EmployeeModel> get employees => _employees;
  bool get isLoading => _isLoading;

  Future<void> fetchEmployees() async {
    _isLoading = true;
    notifyListeners();
    try {
      _employees = await _repository.getEmployees();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addEmployee(EmployeeModel employee) async {
    _isLoading = true;
    notifyListeners();
    try {
      final newEmployee = await _repository.addEmployee(employee);
      _employees.add(newEmployee);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateEmployee(EmployeeModel employee) async {
    _isLoading = true;
    notifyListeners();
    try {
      final updatedEmployee = await _repository.updateEmployee(employee);
      final index = _employees.indexWhere((e) => e.id == updatedEmployee.id);
      if (index >= 0) {
        _employees[index] = updatedEmployee;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> activateEmployee(String id, bool isActive) async {
    _isLoading = true;
    notifyListeners();
    try {
      final updatedEmployee = await _repository.activateEmployee(id, isActive);
      final index = _employees.indexWhere((e) => e.id == id);
      if (index >= 0) {
        _employees[index] = updatedEmployee;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteEmployee(String id) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.deleteEmployee(id);
      _employees.removeWhere((e) => e.id == id);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
