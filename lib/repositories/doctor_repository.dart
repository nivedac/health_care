import '../models/doctor_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/doctor_model.dart';

class DoctorRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'doctors';

  Future<List<DoctorModel>> getDoctors() async {
    final snapshot = await _firestore.collection(_collection).get();
    return snapshot.docs.map((doc) => DoctorModel.fromJson({...doc.data(), 'id': doc.id})).toList();
  }

  Future<DoctorModel?> getDoctorById(String id) async {
    final doc = await _firestore.collection(_collection).doc(id).get();
    if (doc.exists) {
      return DoctorModel.fromJson({...doc.data()!, 'id': doc.id});
    }
    return null;
  }

  Future<DoctorModel> addDoctor(DoctorModel doctor) async {
    final docRef = await _firestore.collection(_collection).add(doctor.toJson());
    return doctor.copyWith(id: docRef.id);
  }

  Future<DoctorModel> updateDoctor(DoctorModel doctor) async {
    await _firestore.collection(_collection).doc(doctor.id).update(doctor.toJson());
    return doctor;
  }

  Future<DoctorModel> deactivateDoctor(String id) async {
    await _firestore.collection(_collection).doc(id).update({'isAvailable': false});
    final doc = await _firestore.collection(_collection).doc(id).get();
    return DoctorModel.fromJson({...doc.data()!, 'id': doc.id});
  }

  Future<void> deleteDoctor(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }
}

