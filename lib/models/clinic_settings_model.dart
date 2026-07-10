import 'package:equatable/equatable.dart';

class ClinicSettingsModel extends Equatable {
  final String clinicName;
  final String address;
  final String contactNumber;
  final String email;
  final int maxTokensPerDoctor;
  final String openingTime;
  final String closingTime;

  const ClinicSettingsModel({
    required this.clinicName,
    required this.address,
    required this.contactNumber,
    required this.email,
    required this.maxTokensPerDoctor,
    required this.openingTime,
    required this.closingTime,
  });

  factory ClinicSettingsModel.fromJson(Map<String, dynamic> json) {
    return ClinicSettingsModel(
      clinicName: json['clinicName'] as String,
      address: json['address'] as String,
      contactNumber: json['contactNumber'] as String,
      email: json['email'] as String,
      maxTokensPerDoctor: json['maxTokensPerDoctor'] as int,
      openingTime: json['openingTime'] as String,
      closingTime: json['closingTime'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clinicName': clinicName,
      'address': address,
      'contactNumber': contactNumber,
      'email': email,
      'maxTokensPerDoctor': maxTokensPerDoctor,
      'openingTime': openingTime,
      'closingTime': closingTime,
    };
  }

  ClinicSettingsModel copyWith({
    String? clinicName,
    String? address,
    String? contactNumber,
    String? email,
    int? maxTokensPerDoctor,
    String? openingTime,
    String? closingTime,
  }) {
    return ClinicSettingsModel(
      clinicName: clinicName ?? this.clinicName,
      address: address ?? this.address,
      contactNumber: contactNumber ?? this.contactNumber,
      email: email ?? this.email,
      maxTokensPerDoctor: maxTokensPerDoctor ?? this.maxTokensPerDoctor,
      openingTime: openingTime ?? this.openingTime,
      closingTime: closingTime ?? this.closingTime,
    );
  }

  @override
  List<Object?> get props => [
        clinicName,
        address,
        contactNumber,
        email,
        maxTokensPerDoctor,
        openingTime,
        closingTime,
      ];
}
