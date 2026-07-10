import 'package:equatable/equatable.dart';

class AppointmentModel extends Equatable {
  final String id;
  final String patientId;
  final String doctorId;
  final DateTime appointmentDate;
  final String status; // 'pending', 'confirmed', 'completed', 'cancelled'
  final String? notes;
  final int? tokenNumber;
  final DateTime? estimatedTime;

  const AppointmentModel({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.appointmentDate,
    required this.status,
    this.notes,
    this.tokenNumber,
    this.estimatedTime,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'] as String,
      patientId: json['patientId'] as String,
      doctorId: json['doctorId'] as String,
      appointmentDate: DateTime.parse(json['appointmentDate'] as String),
      status: json['status'] as String,
      notes: json['notes'] as String?,
      tokenNumber: json['tokenNumber'] as int?,
      estimatedTime: json['estimatedTime'] != null ? DateTime.parse(json['estimatedTime'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'doctorId': doctorId,
      'appointmentDate': appointmentDate.toIso8601String(),
      'status': status,
      'notes': notes,
      'tokenNumber': tokenNumber,
      'estimatedTime': estimatedTime?.toIso8601String(),
    };
  }

  AppointmentModel copyWith({
    String? id,
    String? patientId,
    String? doctorId,
    DateTime? appointmentDate,
    String? status,
    String? notes,
    int? tokenNumber,
    DateTime? estimatedTime,
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
    );
  }

  @override
  List<Object?> get props => [id, patientId, doctorId, appointmentDate, status, notes, tokenNumber, estimatedTime];
}
