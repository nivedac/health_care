import '../models/patient_model.dart';

class PatientRepository {
  final List<PatientModel> _mockPatients = [
    PatientModel(id: 'p1', userId: 'u4', phoneNumber: '1234567890', dateOfBirth: DateTime(1990, 1, 1), gender: 'Male', bloodGroup: 'O+'),
    PatientModel(id: 'p2', userId: 'u5', phoneNumber: '0987654321', dateOfBirth: DateTime(1985, 5, 12), gender: 'Female', bloodGroup: 'A+'),
  ];

  Future<List<PatientModel>> getPatients() async {
    await Future.delayed(const Duration(seconds: 1));
    return _mockPatients;
  }

  Future<PatientModel?> getPatientById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      return _mockPatients.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<PatientModel> addPatient(PatientModel patient) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newPatient = patient.copyWith(id: 'p${_mockPatients.length + 1}');
    _mockPatients.add(newPatient);
    return newPatient;
  }
}
