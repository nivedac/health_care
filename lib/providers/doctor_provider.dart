import 'package:flutter/material.dart';
import '../models/doctor_model.dart';
import '../repositories/doctor_repository.dart';

class DoctorProvider extends ChangeNotifier {
  final DoctorRepository _repository = DoctorRepository();
  List<DoctorModel> _doctors = [];
  bool _isLoading = false;

  List<DoctorModel> get doctors => _doctors;
  bool get isLoading => _isLoading;

  Future<void> fetchDoctors() async {
    _isLoading = true;
    notifyListeners();
    try {
      _doctors = await _repository.getDoctors();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
