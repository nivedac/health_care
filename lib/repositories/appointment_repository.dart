import '../models/appointment_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/appointment_model.dart';

class AppointmentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'appointments';

  Future<List<AppointmentModel>> getAppointments() async {
    final snapshot = await _firestore.collection(_collection).get();
    return snapshot.docs.map((doc) => AppointmentModel.fromJson({...doc.data(), 'id': doc.id})).toList();
  }

  Future<List<AppointmentModel>> getAppointmentsByPatientId(String patientId) async {
    final snapshot = await _firestore.collection(_collection)
        .where('patientId', isEqualTo: patientId)
        .get();
    return snapshot.docs.map((doc) => AppointmentModel.fromJson({...doc.data(), 'id': doc.id})).toList();
  }

  Future<AppointmentModel> bookAppointment(AppointmentModel appointment) async {
    final docRef = await _firestore.collection(_collection).add(appointment.toJson());
    return appointment.copyWith(id: docRef.id);
  }

  Future<void> cancelAppointment(String id) async {
    await _firestore.collection(_collection).doc(id).update({'status': 'cancelled'});
  }
}

