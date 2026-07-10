import 'package:flutter/material.dart';
import '../models/patient_model.dart';
import '../repositories/patient_repository.dart';

class PatientProvider extends ChangeNotifier {
  final PatientRepository _repository = PatientRepository();
  List<PatientModel> _patients = [];
  bool _isLoading = false;

  List<PatientModel> get patients => _patients;
  bool get isLoading => _isLoading;

  Future<void> fetchPatients() async {
    _isLoading = true;
    notifyListeners();
    try {
      _patients = await _repository.getPatients();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addPatient(PatientModel patient) async {
    _isLoading = true;
    notifyListeners();
    try {
      final newPatient = await _repository.addPatient(patient);
      _patients.add(newPatient);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
