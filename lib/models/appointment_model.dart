import 'package:equatable/equatable.dart';

/// Canonical appointment status lifecycle.
/// 
/// These are the ONLY valid appointment statuses in the system.
/// Status transitions are enforced at the repository layer.
/// See APPOINTMENT_LIFECYCLE.md for the full state machine.
enum AppointmentStatus {
  /// Patient has booked; has not yet arrived at the clinic.
  booked,

  /// Patient has checked in at reception; awaiting their turn.
  arrived,

  /// Patient is currently with the doctor.
  inConsultation,

  /// Consultation has been completed successfully.
  completed,

  /// Appointment was cancelled by the patient or clinic staff.
  cancelled,

  /// Patient did not arrive and was marked as no-show by reception.
  noShow,
}

/// Extension helpers for [AppointmentStatus].
extension AppointmentStatusX on AppointmentStatus {
  /// Returns true if this status is considered "active" — i.e., blocks
  /// a new booking for the same patient/doctor/date.
  bool get isActive =>
      this == AppointmentStatus.booked ||
      this == AppointmentStatus.arrived ||
      this == AppointmentStatus.inConsultation;

  /// Returns true if this status allows the same patient to re-book
  /// the same doctor on the same date.
  bool get allowsRebooking =>
      this == AppointmentStatus.cancelled || this == AppointmentStatus.noShow;

  /// Returns the human-readable display label for this status.
  String get displayLabel {
    switch (this) {
      case AppointmentStatus.booked:
        return 'Booked';
      case AppointmentStatus.arrived:
        return 'Arrived';
      case AppointmentStatus.inConsultation:
        return 'In Consultation';
      case AppointmentStatus.completed:
        return 'Completed';
      case AppointmentStatus.cancelled:
        return 'Cancelled';
      case AppointmentStatus.noShow:
        return 'No Show';
    }
  }

  /// Parses a Firestore status string into an [AppointmentStatus].
  /// Falls back to [AppointmentStatus.booked] for any unknown value.
  static AppointmentStatus fromString(String? value) {
    return AppointmentStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AppointmentStatus.booked,
    );
  }
}

class AppointmentModel extends Equatable {
  final String id;
  final String patientId;
  final String doctorId;
  final DateTime appointmentDate;
  final AppointmentStatus status;
  final String? notes;
  final int? tokenNumber;
  final DateTime? estimatedTime;
  final DateTime? createdAt;

  const AppointmentModel({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.appointmentDate,
    required this.status,
    this.notes,
    this.tokenNumber,
    this.estimatedTime,
    this.createdAt,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'] as String? ?? '',
      patientId: json['patientId'] as String,
      doctorId: json['doctorId'] as String,
      appointmentDate: DateTime.parse(json['appointmentDate'] as String),
      status: AppointmentStatusX.fromString(json['status'] as String?),
      notes: json['notes'] as String?,
      tokenNumber: json['tokenNumber'] as int?,
      estimatedTime: json['estimatedTime'] != null
          ? DateTime.parse(json['estimatedTime'] as String)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patientId': patientId,
      'doctorId': doctorId,
      'appointmentDate': appointmentDate.toIso8601String(),
      'status': status.name,
      'notes': notes,
      'tokenNumber': tokenNumber,
      'estimatedTime': estimatedTime?.toIso8601String(),
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    };
  }

  AppointmentModel copyWith({
    String? id,
    String? patientId,
    String? doctorId,
    DateTime? appointmentDate,
    AppointmentStatus? status,
    String? notes,
    int? tokenNumber,
    DateTime? estimatedTime,
    DateTime? createdAt,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      doctorId: doctorId ?? this.doctorId,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      tokenNumber: tokenNumber ?? this.tokenNumber,
      estimatedTime: estimatedTime ?? this.estimatedTime,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        patientId,
        doctorId,
        appointmentDate,
        status,
        notes,
        tokenNumber,
        estimatedTime,
        createdAt,
      ];
}
