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

  Future<void> addDoctor(DoctorModel doctor) async {
    _isLoading = true;
    notifyListeners();
    try {
      final newDoctor = await _repository.addDoctor(doctor);
      _doctors.add(newDoctor);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateDoctor(DoctorModel doctor) async {
    _isLoading = true;
    notifyListeners();
    try {
      final updatedDoctor = await _repository.updateDoctor(doctor);
      final index = _doctors.indexWhere((d) => d.id == updatedDoctor.id);
      if (index >= 0) {
        _doctors[index] = updatedDoctor;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deactivateDoctor(String id) async {
    _isLoading = true;
    notifyListeners();
    try {
      final updatedDoctor = await _repository.deactivateDoctor(id);
      final index = _doctors.indexWhere((d) => d.id == id);
      if (index >= 0) {
        _doctors[index] = updatedDoctor;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteDoctor(String id) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.deleteDoctor(id);
      _doctors.removeWhere((d) => d.id == id);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
