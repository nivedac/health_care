import '../models/clinic_settings_model.dart';

class SettingsRepository {
  ClinicSettingsModel _mockSettings = const ClinicSettingsModel(
    clinicName: 'MedClinic Pro',
    address: '123 Health Ave, Medical City',
    contactNumber: '+1 234 567 8900',
    email: 'contact@medclinic.pro',
    maxTokensPerDoctor: 50,
    openingTime: '08:00 AM',
    closingTime: '08:00 PM',
  );

  Future<ClinicSettingsModel> getSettings() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockSettings;
  }

  Future<ClinicSettingsModel> updateSettings(ClinicSettingsModel settings) async {
    await Future.delayed(const Duration(seconds: 1));
    _mockSettings = settings;
    return _mockSettings;
  }
}
