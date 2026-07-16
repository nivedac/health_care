import 'package:equatable/equatable.dart';

enum QueueStatus {
  booked,
  waiting,
  arrived,
  called,
  inConsultation,
  completed,
  skipped,
  cancelled
}

class TokenModel extends Equatable {
  final String id;
  final String appointmentId;
  final int tokenNumber; 
  final DateTime issuedAt;
  final DateTime? estimatedTime;
  final QueueStatus status;
  final String? patientId;
  final String? patientName;
  final String? patientPhone;

  const TokenModel({
    required this.id,
    required this.appointmentId,
    required this.tokenNumber,
    required this.issuedAt,
    this.estimatedTime,
    this.status = QueueStatus.booked,
    this.patientId,
    this.patientName,
    this.patientPhone,
  });

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      id: json['id'] as String,
      appointmentId: json['appointmentId'] as String,
      tokenNumber: json['tokenNumber'] as int,
      issuedAt: DateTime.parse(json['issuedAt'] as String),
      estimatedTime: json['estimatedTime'] != null ? DateTime.parse(json['estimatedTime'] as String) : null,
      status: QueueStatus.values.firstWhere((e) => e.name == json['status'], orElse: () => QueueStatus.booked),
      patientId: json['patientId'] as String?,
      patientName: json['patientName'] as String?,
      patientPhone: json['patientPhone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'appointmentId': appointmentId,
      'tokenNumber': tokenNumber,
      'issuedAt': issuedAt.toIso8601String(),
      'estimatedTime': estimatedTime?.toIso8601String(),
      'status': status.name,
      'patientId': patientId,
      'patientName': patientName,
      'patientPhone': patientPhone,
    };
  }

  TokenModel copyWith({
    String? id,
    String? appointmentId,
    int? tokenNumber,
    DateTime? issuedAt,
    DateTime? estimatedTime,
    QueueStatus? status,
    String? patientId,
    String? patientName,
    String? patientPhone,
  }) {
    return TokenModel(
      id: id ?? this.id,
      appointmentId: appointmentId ?? this.appointmentId,
      tokenNumber: tokenNumber ?? this.tokenNumber,
      issuedAt: issuedAt ?? this.issuedAt,
      estimatedTime: estimatedTime ?? this.estimatedTime,
      status: status ?? this.status,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      patientPhone: patientPhone ?? this.patientPhone,
    );
  }

  @override
  List<Object?> get props => [id, appointmentId, tokenNumber, issuedAt, estimatedTime, status, patientId, patientName, patientPhone];
}
