import 'package:flutter/material.dart';
import '../models/holiday_model.dart';
import '../repositories/holiday_repository.dart';

class HolidayProvider extends ChangeNotifier {
  final HolidayRepository _repository = HolidayRepository();
  List<HolidayModel> _holidays = [];
  bool _isLoading = false;

  List<HolidayModel> get holidays => _holidays;
  bool get isLoading => _isLoading;

  Future<void> fetchHolidays() async {
    _isLoading = true;
    notifyListeners();
    try {
      _holidays = await _repository.getHolidays();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addHoliday(HolidayModel holiday) async {
    _isLoading = true;
    notifyListeners();
    try {
      final newHoliday = await _repository.addHoliday(holiday);
      _holidays.add(newHoliday);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateHoliday(HolidayModel holiday) async {
    _isLoading = true;
    notifyListeners();
    try {
      final updatedHoliday = await _repository.updateHoliday(holiday);
      final index = _holidays.indexWhere((h) => h.id == updatedHoliday.id);
      if (index >= 0) {
        _holidays[index] = updatedHoliday;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteHoliday(String id) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.deleteHoliday(id);
      _holidays.removeWhere((h) => h.id == id);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
