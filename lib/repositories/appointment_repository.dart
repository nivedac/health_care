import '../models/appointment_model.dart';

class AppointmentRepository {
  final List<AppointmentModel> _mockAppointments = [
    AppointmentModel(
      id: 'a1',
      patientId: 'p1',
      doctorId: 'd1',
      appointmentDate: DateTime.now().add(const Duration(hours: 1)),
      status: 'pending',
    ),
    AppointmentModel(
      id: 'a2',
      patientId: 'p2',
      doctorId: 'd2',
      appointmentDate: DateTime.now().subtract(const Duration(days: 1)),
      status: 'completed',
    ),
  ];

  Future<List<AppointmentModel>> getAppointments() async {
    await Future.delayed(const Duration(seconds: 1));
    return _mockAppointments;
  }

  Future<List<AppointmentModel>> getAppointmentsByPatientId(String patientId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockAppointments.where((a) => a.patientId == patientId).toList();
  }

  Future<AppointmentModel> bookAppointment(AppointmentModel appointment) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newAppointment = appointment.copyWith(id: 'a${_mockAppointments.length + 1}');
    _mockAppointments.add(newAppointment);
    return newAppointment;
  }

  Future<void> cancelAppointment(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _mockAppointments.indexWhere((a) => a.id == id);
    if (index != -1) {
      _mockAppointments[index] = _mockAppointments[index].copyWith(status: 'cancelled');
    }
  }
}
