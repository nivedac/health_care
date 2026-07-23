import 'package:flutter_test/flutter_test.dart';
import 'package:baijus/models/patient_model.dart';

void main() {
  group('PatientModel', () {
    test('supports walk-in properties correctly', () {
      final model = PatientModel(
        id: 'random-uuid',
        userId: 'random-uuid',
        fullName: 'John Doe',
        phoneNumber: '+919876543210',
        age: 30,
        gender: 'male',
      );

      expect(model.id, equals('random-uuid'));
      expect(model.userId, equals('random-uuid'));
      expect(model.fullName, equals('John Doe'));
      expect(model.phoneNumber, equals('+919876543210'));
      expect(model.age, equals(30));
      expect(model.gender, equals('male'));

      final json = model.toJson();
      expect(json['id'], equals('random-uuid'));
      expect(json['userId'], equals('random-uuid'));
      expect(json['age'], equals(30));
      expect(json['gender'], equals('male'));
      
      final parsed = PatientModel.fromJson(json);
      expect(parsed.id, equals(model.id));
      expect(parsed.age, equals(model.age));
    });
  });
}
