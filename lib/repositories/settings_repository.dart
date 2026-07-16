import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/clinic_settings_model.dart';

class SettingsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'settings';
  final String _settingsDocId = 'clinic_settings'; // Singleton document

  Future<ClinicSettingsModel> getSettings() async {
    final doc = await _firestore.collection(_collection).doc(_settingsDocId).get();
    if (doc.exists) {
      return ClinicSettingsModel.fromJson(doc.data()!);
    } else {
      // Default settings
      const defaultSettings = ClinicSettingsModel(
        clinicName: 'MedClinic Pro',
        address: '123 Health Ave, Medical City',
        contactNumber: '+1 234 567 8900',
        email: 'contact@medclinic.pro',
        maxTokensPerDoctor: 50,
        openingTime: '08:00 AM',
        closingTime: '08:00 PM',
      );
      await _firestore.collection(_collection).doc(_settingsDocId).set(defaultSettings.toJson());
      return defaultSettings;
    }
  }

  Future<ClinicSettingsModel> updateSettings(ClinicSettingsModel settings) async {
    await _firestore.collection(_collection).doc(_settingsDocId).set(settings.toJson());
    return settings;
  }
}

