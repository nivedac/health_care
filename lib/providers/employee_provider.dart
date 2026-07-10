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
}
