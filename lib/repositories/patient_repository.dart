import '../models/patient_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

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
  
  /// Fetches a patient by their associated Auth User ID
  Future<PatientModel?> getPatientByUserId(String userId) async {
    final snapshot = await _firestore.collection(_collection).where('userId', isEqualTo: userId).limit(1).get();
    if (snapshot.docs.isNotEmpty) {
      final doc = snapshot.docs.first;
      return PatientModel.fromJson({...doc.data(), 'id': doc.id});
    }
    return null;
  }

  Future<PatientModel> addPatient(PatientModel patient) async {
    final docRef = await _firestore.collection(_collection).add(patient.toJson());
    return patient.copyWith(id: docRef.id);
  }

  /// Creates or updates a patient profile, ensuring the ID matches the userId for a 1:1 relationship
  Future<PatientModel> addOrUpdatePatientProfile(PatientModel patient) async {
    try {
      // Use the userId as the document ID for 1:1 mapping.
      final docRef = _firestore.collection(_collection).doc(patient.userId);
      await docRef.set({
        ...patient.toJson(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      return patient.copyWith(id: patient.userId);
    } catch (e) {
      debugPrint('Error updating patient profile: $e');
      rethrow;
    }
  }
}

