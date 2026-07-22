import 'package:flutter/material.dart';
import '../models/appointment_model.dart';
import '../repositories/appointment_repository.dart';
import '../repositories/booking_repository.dart';
import '../core/error_handler.dart';

class AppointmentProvider extends ChangeNotifier {
  final AppointmentRepository _repository = AppointmentRepository();
  final BookingRepository _bookingRepo = BookingRepository();

  List<AppointmentModel> _appointments = [];
  bool _isLoading = false;
  String? _lastBookingError;

  List<AppointmentModel> get appointments => _appointments;
  bool get isLoading => _isLoading;
  String? get lastBookingError => _lastBookingError;

  // --------------------------------------------------------------------------
  // FETCH
  // --------------------------------------------------------------------------

  /// Fetches all appointments (staff use only).
  Future<void> fetchAppointments() async {
    _isLoading = true;
    notifyListeners();
    try {
      _appointments = await _repository.getAppointments();
    } catch (e, stackTrace) {
      ErrorHandler.handleError(e, stackTrace: stackTrace);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetches a patient's own appointment history.
  Future<void> fetchAppointmentsForPatient(String patientId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _appointments = await _repository.getAppointmentsByPatientId(patientId);
    } catch (e, stackTrace) {
      ErrorHandler.handleError(e, stackTrace: stackTrace);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --------------------------------------------------------------------------
  // BOOK (delegates to BookingRepository for atomic transaction)
  // --------------------------------------------------------------------------

  /// Books an appointment atomically via [BookingRepository].
  ///
  /// Returns the [BookingResult] on success, or null on failure.
  /// Sets [lastBookingError] with a user-friendly message on failure.
  Future<BookingResult?> bookAppointment({
    required String patientId,
    required String patientName,
    String? patientPhone,
    required String doctorId,
    required DateTime appointmentDate,
    String? notes,
  }) async {
    _isLoading = true;
    _lastBookingError = null;
    notifyListeners();

    try {
      final result = await _bookingRepo.bookAppointmentTransactionally(
        patientId: patientId,
        patientName: patientName,
        patientPhone: patientPhone,
        doctorId: doctorId,
        appointmentDate: appointmentDate,
        notes: notes,
      );

      // Optimistically add to local list
      _appointments.add(AppointmentModel(
        id: result.appointmentId,
        patientId: patientId,
        doctorId: doctorId,
        appointmentDate: appointmentDate,
        status: AppointmentStatus.booked,
        tokenNumber: result.tokenNumber,
        notes: notes,
      ));

      return result;
    } on BookingClosedException catch (e) {
      _lastBookingError = e.message;
      notifyListeners();
      return null;
    } on DuplicateBookingException catch (e) {
      _lastBookingError = e.message;
      notifyListeners();
      return null;
    } catch (e, stackTrace) {
      _lastBookingError = 'Booking failed. Please try again.';
      ErrorHandler.handleError(e, stackTrace: stackTrace);
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --------------------------------------------------------------------------
  // CANCEL (atomic via BookingRepository)
  // --------------------------------------------------------------------------

  /// Cancels an appointment atomically, releasing the booking lock.
  Future<void> cancelAppointment(String id) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _bookingRepo.cancelAppointment(id);
      final index = _appointments.indexWhere((a) => a.id == id);
      if (index != -1) {
        _appointments[index] =
            _appointments[index].copyWith(status: AppointmentStatus.cancelled);
      }
    } on AppointmentNotFoundException catch (e) {
      _lastBookingError = e.message;
    } catch (e, stackTrace) {
      ErrorHandler.handleError(e, stackTrace: stackTrace);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --------------------------------------------------------------------------
  // CLEAR ERROR
  // --------------------------------------------------------------------------

  void clearError() {
    _lastBookingError = null;
    notifyListeners();
  }
}
