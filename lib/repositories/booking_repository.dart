import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/appointment_model.dart';

// ============================================================================
// BOOKING EXCEPTION HIERARCHY
// ============================================================================

/// Base class for all booking-related errors.
abstract class BookingException implements Exception {
  final String message;
  const BookingException(this.message);

  @override
  String toString() => 'BookingException: $message';
}

/// Thrown when booking is administratively closed.
/// Admin can toggle `settings/clinic_settings.isBookingOpen = false`.
class BookingClosedException extends BookingException {
  const BookingClosedException([super.message = 'Booking is currently closed.']);
  @override
  String toString() => 'BookingClosedException: $message';
}

/// Thrown when the patient already has an active booking for the same
/// doctor on the same date.
class DuplicateBookingException extends BookingException {
  const DuplicateBookingException(
      [super.message =
          'You already have an active booking for this date and doctor.']);
  @override
  String toString() => 'DuplicateBookingException: $message';
}

/// Thrown when the appointment to cancel is not found or already terminal.
class AppointmentNotFoundException extends BookingException {
  const AppointmentNotFoundException(
      [super.message = 'Appointment not found or already closed.']);
  @override
  String toString() => 'AppointmentNotFoundException: $message';
}

// ============================================================================
// BOOKING RESULT
// ============================================================================

/// Returned by a successful [BookingRepository.bookAppointmentTransactionally].
class BookingResult {
  /// The newly created Firestore appointment document ID.
  final String appointmentId;

  /// The atomically assigned token number (1-based, scoped to doctor+date).
  final int tokenNumber;

  const BookingResult({required this.appointmentId, required this.tokenNumber});
}

// ============================================================================
// BOOKING REPOSITORY
// ============================================================================

/// Handles the full atomic booking lifecycle.
///
/// All booking operations (create, cancel) are executed inside Firestore
/// transactions to guarantee consistency under concurrent requests.
///
/// ## Collections managed by this repository
///
/// | Collection | Document ID | Purpose |
/// |------------|-------------|---------|
/// | `appointments` | auto-id | Appointment record |
/// | `tokenCounters` | `{doctorId}_{YYYY-MM-DD}` | Atomic per-day token counter |
/// | `bookingLocks` | `{patientId}_{doctorId}_{YYYY-MM-DD}` | Prevents duplicate bookings |
///
/// ## Security Posture
///
/// - Duplicate detection: enforced atomically via Firestore transaction.
///   A malicious client cannot bypass this without the lock document's help.
/// - Token number integrity: enforced via atomic counter increment.
///   Concurrent bookings will get distinct, monotonically increasing numbers.
/// - `isBookingOpen` check: performed server-side via Firestore Security Rules
///   AND as a pre-check here. Two layers — rules are the authoritative gate.
/// - `patientId == auth.uid` enforcement: enforced by Firestore Security Rules.
class BookingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String _appointmentsCol = 'appointments';
  static const String _tokenCountersCol = 'tokenCounters';
  static const String _bookingLocksCol = 'bookingLocks';
  static const String _settingsCol = 'settings';
  static const String _settingsDoc = 'clinic_settings';

  // --------------------------------------------------------------------------
  // HELPERS
  // --------------------------------------------------------------------------

  /// Returns `YYYY-MM-DD` from [date]. Used as the date component in
  /// document IDs and compound queries.
  static String dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  /// Returns the `tokenCounters` document ID for a given doctor and date.
  static String counterDocId(String doctorId, DateTime date) =>
      '${doctorId}_${dateKey(date)}';

  /// Returns the `bookingLocks` document ID — deterministic from the
  /// combination of patient, doctor, and date.
  static String lockDocId(String patientId, String doctorId, DateTime date) =>
      '${patientId}_${doctorId}_${dateKey(date)}';

  // --------------------------------------------------------------------------
  // BOOK (ATOMIC TRANSACTION)
  // --------------------------------------------------------------------------

  /// Books an appointment atomically.
  ///
  /// The operation runs inside a single [FirebaseFirestore.runTransaction] that
  /// touches exactly 3 documents:
  ///   1. `tokenCounters/{doctorId}_{date}` — reads and increments counter
  ///   2. `bookingLocks/{patientId}_{doctorId}_{date}` — asserts no active
  ///      booking, then writes lock
  ///   3. `appointments/{newId}` — creates the appointment document
  ///
  /// Throws [BookingClosedException] if `settings.isBookingOpen == false`.
  /// Throws [DuplicateBookingException] if an active booking lock exists.
  /// Rethrows any Firestore exceptions for the caller to handle.
  Future<BookingResult> bookAppointmentTransactionally({
    required String patientId,
    required String patientName,
    required String? patientPhone,
    required String doctorId,
    required DateTime appointmentDate,
    String? notes,
  }) async {
    // ---- Pre-check: isBookingOpen (also enforced server-side by Firestore Rules)
    final settingsSnap = await _firestore
        .collection(_settingsCol)
        .doc(_settingsDoc)
        .get();
    if (settingsSnap.exists) {
      final isBookingOpen =
          settingsSnap.data()?['isBookingOpen'] as bool? ?? true;
      if (!isBookingOpen) {
        throw const BookingClosedException(
            'Booking is currently closed by the clinic. Please try again later.');
      }
    }

    final dateStr = dateKey(appointmentDate);
    final lockId = lockDocId(patientId, doctorId, appointmentDate);
    final counterDocRef =
        _firestore.collection(_tokenCountersCol).doc(counterDocId(doctorId, appointmentDate));
    final lockRef = _firestore.collection(_bookingLocksCol).doc(lockId);
    final appointmentRef = _firestore.collection(_appointmentsCol).doc();

    return await _firestore.runTransaction<BookingResult>((tx) async {
      // -- Read 1: token counter
      final counterSnap = await tx.get(counterDocRef);
      final lastToken =
          counterSnap.exists ? (counterSnap.data()?['lastTokenNumber'] as int? ?? 0) : 0;
      final nextTokenNumber = lastToken + 1;

      // -- Read 2: booking lock — duplicate check
      final lockSnap = await tx.get(lockRef);
      if (lockSnap.exists) {
        final lockStatus = lockSnap.data()?['status'] as String? ?? '';
        final isActive = AppointmentStatus.values
            .firstWhere((e) => e.name == lockStatus,
                orElse: () => AppointmentStatus.cancelled)
            .isActive;
        if (isActive) {
          throw const DuplicateBookingException();
        }
      }

      final nowTs = FieldValue.serverTimestamp();

      // -- Write 1: appointment document
      tx.set(appointmentRef, {
        'patientId': patientId,
        'patientName': patientName,
        'patientPhone': patientPhone,
        'doctorId': doctorId,
        'appointmentDate': appointmentDate.toIso8601String(),
        'status': AppointmentStatus.booked.name,
        'tokenNumber': nextTokenNumber,
        'notes': notes,
        'createdAt': nowTs,
      });

      // -- Write 2: booking lock
      tx.set(lockRef, {
        'patientId': patientId,
        'doctorId': doctorId,
        'date': dateStr,
        'appointmentId': appointmentRef.id,
        'status': AppointmentStatus.booked.name,
        'updatedAt': nowTs,
        if (!lockSnap.exists) 'createdAt': nowTs,
        if (lockSnap.exists) 'createdAt': lockSnap.data()?['createdAt'],
      });

      // -- Write 3: token counter
      tx.set(counterDocRef, {
        'doctorId': doctorId,
        'date': dateStr,
        'lastTokenNumber': nextTokenNumber,
        'updatedAt': nowTs,
      });

      return BookingResult(
        appointmentId: appointmentRef.id,
        tokenNumber: nextTokenNumber,
      );
    });
  }

  // --------------------------------------------------------------------------
  // CANCEL (ATOMIC TRANSACTION)
  // --------------------------------------------------------------------------

  /// Cancels an appointment atomically.
  ///
  /// Updates both the appointment document and the corresponding booking lock
  /// in one transaction, so the patient can re-book the same doctor on
  /// the same date after cancellation.
  ///
  /// Only allows cancellation of appointments in status [AppointmentStatus.booked]
  /// or [AppointmentStatus.arrived]. Cannot cancel an in-consultation or
  /// completed appointment.
  ///
  /// Throws [AppointmentNotFoundException] if the appointment doesn't exist.
  /// Throws [BookingException] if the status doesn't allow cancellation.
  Future<void> cancelAppointment(String appointmentId) async {
    final appointmentRef =
        _firestore.collection(_appointmentsCol).doc(appointmentId);

    await _firestore.runTransaction((tx) async {
      final snap = await tx.get(appointmentRef);
      if (!snap.exists) throw const AppointmentNotFoundException();

      final data = snap.data()!;
      final currentStatus = AppointmentStatusX.fromString(data['status'] as String?);

      // Only booked or arrived appointments can be patient-cancelled
      if (currentStatus != AppointmentStatus.booked &&
          currentStatus != AppointmentStatus.arrived) {
        throw InvalidStatusTransitionException(
            'Cannot cancel an appointment with status: ${currentStatus.name}');
      }

      final patientId = data['patientId'] as String;
      final doctorId = data['doctorId'] as String;
      final appointmentDate = DateTime.parse(data['appointmentDate'] as String);
      final lockId = lockDocId(patientId, doctorId, appointmentDate);
      final lockRef = _firestore.collection(_bookingLocksCol).doc(lockId);

      final nowTs = FieldValue.serverTimestamp();

      // Update appointment status
      tx.update(appointmentRef, {
        'status': AppointmentStatus.cancelled.name,
        'cancelledAt': nowTs,
      });

      // Release the booking lock (allow re-booking)
      tx.update(lockRef, {
        'status': AppointmentStatus.cancelled.name,
        'updatedAt': nowTs,
      });
    });
  }

  // --------------------------------------------------------------------------
  // STAFF: UPDATE STATUS (non-transactional — staff operations are trusted)
  // --------------------------------------------------------------------------

  /// Updates appointment status from the staff side (reception/admin).
  ///
  /// Called when reception marks a patient as [arrived], [inConsultation],
  /// [completed], or [noShow].
  ///
  /// SECURITY NOTE: This method is protected by Firestore Security Rules
  /// (only staff can write to `appointments`). The status string is
  /// validated server-side by the Rules.
  Future<void> updateAppointmentStatus(
    String appointmentId,
    AppointmentStatus newStatus,
  ) async {
    await _firestore.collection(_appointmentsCol).doc(appointmentId).update({
      'status': newStatus.name,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // --------------------------------------------------------------------------
  // READ — get patient's active booking for a given doctor+date
  // --------------------------------------------------------------------------

  /// Returns the patient's active appointment for a given [doctorId] and [date],
  /// or null if no active booking exists.
  Future<AppointmentModel?> getActiveBookingForPatient({
    required String patientId,
    required String doctorId,
    required DateTime date,
  }) async {
    final lockId = lockDocId(patientId, doctorId, date);
    final lockSnap =
        await _firestore.collection(_bookingLocksCol).doc(lockId).get();
    if (!lockSnap.exists) return null;

    final lockStatus = lockSnap.data()?['status'] as String? ?? '';
    final isActive = AppointmentStatusX.fromString(lockStatus).isActive;
    if (!isActive) return null;

    final appointmentId = lockSnap.data()?['appointmentId'] as String?;
    if (appointmentId == null) return null;

    final aptSnap = await _firestore
        .collection(_appointmentsCol)
        .doc(appointmentId)
        .get();
    if (!aptSnap.exists) return null;

    return AppointmentModel.fromJson({...aptSnap.data()!, 'id': aptSnap.id});
  }
}

/// Internal exception for invalid appointment status transitions.
class InvalidStatusTransitionException extends BookingException {
  const InvalidStatusTransitionException(super.message);
  @override
  String toString() => 'BookingException: $message';
}
