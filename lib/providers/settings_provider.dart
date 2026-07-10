import 'package:flutter/material.dart';
import '../models/clinic_settings_model.dart';
import '../repositories/settings_repository.dart';

class SettingsProvider extends ChangeNotifier {
  final SettingsRepository _repository = SettingsRepository();
  ClinicSettingsModel? _settings;
  bool _isLoading = false;

  ClinicSettingsModel? get settings => _settings;
  bool get isLoading => _isLoading;

  Future<void> fetchSettings() async {
    _isLoading = true;
    notifyListeners();
    try {
      _settings = await _repository.getSettings();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateSettings(ClinicSettingsModel newSettings) async {
    _isLoading = true;
    notifyListeners();
    try {
      _settings = await _repository.updateSettings(newSettings);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
