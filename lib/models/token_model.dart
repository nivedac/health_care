import 'package:equatable/equatable.dart';

class TokenModel extends Equatable {
  final String id;
  final String appointmentId;
  final String tokenNumber; // e.g., 'A12'
  final DateTime issuedAt;
  final DateTime? estimatedTime;

  const TokenModel({
    required this.id,
    required this.appointmentId,
    required this.tokenNumber,
    required this.issuedAt,
    this.estimatedTime,
  });

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      id: json['id'] as String,
      appointmentId: json['appointmentId'] as String,
      tokenNumber: json['tokenNumber'] as String,
      issuedAt: DateTime.parse(json['issuedAt'] as String),
      estimatedTime: json['estimatedTime'] != null ? DateTime.parse(json['estimatedTime'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'appointmentId': appointmentId,
      'tokenNumber': tokenNumber,
      'issuedAt': issuedAt.toIso8601String(),
      'estimatedTime': estimatedTime?.toIso8601String(),
    };
  }

  TokenModel copyWith({
    String? id,
    String? appointmentId,
    String? tokenNumber,
    DateTime? issuedAt,
    DateTime? estimatedTime,
  }) {
    return TokenModel(
      id: id ?? this.id,
      appointmentId: appointmentId ?? this.appointmentId,
      tokenNumber: tokenNumber ?? this.tokenNumber,
      issuedAt: issuedAt ?? this.issuedAt,
      estimatedTime: estimatedTime ?? this.estimatedTime,
    );
  }

  @override
  List<Object?> get props => [id, appointmentId, tokenNumber, issuedAt, estimatedTime];
}
