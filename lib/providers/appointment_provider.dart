import 'package:flutter/material.dart';
import '../models/appointment_model.dart';
import '../repositories/appointment_repository.dart';

class AppointmentProvider extends ChangeNotifier {
  final AppointmentRepository _repository = AppointmentRepository();
  List<AppointmentModel> _appointments = [];
  bool _isLoading = false;

  List<AppointmentModel> get appointments => _appointments;
  bool get isLoading => _isLoading;

  Future<void> fetchAppointments() async {
    _isLoading = true;
    notifyListeners();
    try {
      _appointments = await _repository.getAppointments();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAppointmentsForPatient(String patientId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _appointments = await _repository.getAppointmentsByPatientId(patientId);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> bookAppointment(AppointmentModel appointment) async {
    _isLoading = true;
    notifyListeners();
    try {
      final newAppt = await _repository.bookAppointment(appointment);
      _appointments.add(newAppt);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> cancelAppointment(String id) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.cancelAppointment(id);
      final index = _appointments.indexWhere((a) => a.id == id);
      if (index != -1) {
        _appointments[index] = _appointments[index].copyWith(status: 'cancelled');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
