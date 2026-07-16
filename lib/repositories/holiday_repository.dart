import '../models/holiday_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class HolidayRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'holidays';

  Future<List<HolidayModel>> getHolidays() async {
    final snapshot = await _firestore.collection(_collection).get();
    return snapshot.docs.map((doc) => HolidayModel.fromJson({...doc.data(), 'id': doc.id})).toList();
  }

  Future<HolidayModel> addHoliday(HolidayModel holiday) async {
    final docRef = await _firestore.collection(_collection).add(holiday.toJson());
    return holiday.copyWith(id: docRef.id);
  }

  Future<HolidayModel> updateHoliday(HolidayModel holiday) async {
    await _firestore.collection(_collection).doc(holiday.id).update(holiday.toJson());
    return holiday;
  }

  Future<void> deleteHoliday(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }
}

