import '../models/appointment_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Read-only appointment access for staff dashboards and patient history.
///
/// Write operations (booking, cancellation) are handled by [BookingRepository].
class AppointmentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'appointments';

  /// Fetches all appointments. Called from staff dashboards only.
  /// Patients must use [getAppointmentsByPatientId] instead.
  Future<List<AppointmentModel>> getAppointments() async {
    final snapshot = await _firestore.collection(_collection).get();
    return snapshot.docs
        .map((doc) => AppointmentModel.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }

  /// Fetches all appointments for a specific patient.
  Future<List<AppointmentModel>> getAppointmentsByPatientId(
      String patientId) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('patientId', isEqualTo: patientId)
        .get();
    return snapshot.docs
        .map((doc) => AppointmentModel.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }

  /// Fetches appointments for a doctor on a specific date.
  /// Used by reception dashboard for daily patient list.
  Future<List<AppointmentModel>> getAppointmentsByDoctorAndDate({
    required String doctorId,
    required DateTime date,
  }) async {
    final dayStart = DateTime(date.year, date.month, date.day);
    final dayEnd = dayStart.add(const Duration(days: 1));
    final snapshot = await _firestore
        .collection(_collection)
        .where('doctorId', isEqualTo: doctorId)
        .where('appointmentDate',
            isGreaterThanOrEqualTo: dayStart.toIso8601String())
        .where('appointmentDate', isLessThan: dayEnd.toIso8601String())
        .get();
    return snapshot.docs
        .map((doc) => AppointmentModel.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }
}
