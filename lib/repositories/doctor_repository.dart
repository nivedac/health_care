import '../models/doctor_model.dart';

class DoctorRepository {
  final List<DoctorModel> _mockDoctors = [
    const DoctorModel(id: 'd1', userId: 'u3', name: 'Dr. Baiju', specialization: 'General Physician'),
    const DoctorModel(id: 'd2', userId: 'u6', name: 'Dr. Smith', specialization: 'Cardiologist'),
    const DoctorModel(id: 'd3', userId: 'u7', name: 'Dr. Richards', specialization: 'Dermatologist'),
  ];

  Future<List<DoctorModel>> getDoctors() async {
    await Future.delayed(const Duration(seconds: 1));
    return _mockDoctors;
  }

  Future<DoctorModel?> getDoctorById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      return _mockDoctors.firstWhere((d) => d.id == id);
    } catch (e) {
      return null;
    }
  }
}
