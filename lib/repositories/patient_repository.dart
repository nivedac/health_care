import '../models/patient_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class PatientRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'patients';

  Future<List<PatientModel>> getPatients() async {
    final snapshot = await _firestore.collection(_collection).get();
    return snapshot.docs.map((doc) => PatientModel.fromJson({...doc.data(), 'id': doc.id})).toList();
  }

  Future<PatientModel?> getPatientById(String id) async {
    final doc = await _firestore.collection(_collection).doc(id).get();
    if (doc.exists) {
      return PatientModel.fromJson({...doc.data()!, 'id': doc.id});
    }
    return null;
  }

  Future<PatientModel> addPatient(PatientModel patient) async {
    final docRef = await _firestore.collection(_collection).add(patient.toJson());
    return patient.copyWith(id: docRef.id);
  }
}

