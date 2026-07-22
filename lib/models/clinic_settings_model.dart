import 'package:equatable/equatable.dart';

class ClinicSettingsModel extends Equatable {
  final String? id;
  final String clinicName;
  final String address;
  final String clinicAddress;
  final String contactNumber;
  final String phoneNumber;
  final String email;
  final int maxTokensPerDoctor;
  final String openingTime;
  final String closingTime;
  final double consultationFee;
  final int averageConsultationTimeMinutes;
  final int maximumDailyPatients;
  final bool isQueueEnabled;
  final bool isBookingOpen;
  final String? tokenPrefix;

  const ClinicSettingsModel({
    this.id,
    required this.clinicName,
    this.address = '',
    this.clinicAddress = '',
    this.contactNumber = '',
    this.phoneNumber = '',
    this.email = '',
    this.maxTokensPerDoctor = 50,
    required this.openingTime,
    required this.closingTime,
    this.consultationFee = 500.0,
    this.averageConsultationTimeMinutes = 15,
    this.maximumDailyPatients = 50,
    this.isQueueEnabled = true,
    this.isBookingOpen = true,
    this.tokenPrefix,
  });

  factory ClinicSettingsModel.fromJson(Map<String, dynamic> json) {
    return ClinicSettingsModel(
      id: json['id'] as String?,
      clinicName: json['clinicName'] as String? ?? '',
      address: json['address'] as String? ?? '',
      clinicAddress: json['clinicAddress'] as String? ?? json['address'] as String? ?? '',
      contactNumber: json['contactNumber'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? json['contactNumber'] as String? ?? '',
      email: json['email'] as String? ?? '',
      maxTokensPerDoctor: json['maxTokensPerDoctor'] as int? ?? 50,
      openingTime: json['openingTime'] as String? ?? '08:00 AM',
      closingTime: json['closingTime'] as String? ?? '08:00 PM',
      consultationFee: (json['consultationFee'] as num?)?.toDouble() ?? 500.0,
      averageConsultationTimeMinutes: json['averageConsultationTimeMinutes'] as int? ?? 15,
      maximumDailyPatients: json['maximumDailyPatients'] as int? ?? 50,
      isQueueEnabled: json['isQueueEnabled'] as bool? ?? true,
      isBookingOpen: json['isBookingOpen'] as bool? ?? true,
      tokenPrefix: json['tokenPrefix'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'clinicName': clinicName,
      'address': address,
      'clinicAddress': clinicAddress,
      'contactNumber': contactNumber,
      'phoneNumber': phoneNumber,
      'email': email,
      'maxTokensPerDoctor': maxTokensPerDoctor,
      'openingTime': openingTime,
      'closingTime': closingTime,
      'consultationFee': consultationFee,
      'averageConsultationTimeMinutes': averageConsultationTimeMinutes,
      'maximumDailyPatients': maximumDailyPatients,
      'isQueueEnabled': isQueueEnabled,
      'isBookingOpen': isBookingOpen,
      'tokenPrefix': tokenPrefix,
    };
  }

  ClinicSettingsModel copyWith({
    String? id,
    String? clinicName,
    String? address,
    String? clinicAddress,
    String? contactNumber,
    String? phoneNumber,
    String? email,
    int? maxTokensPerDoctor,
    String? openingTime,
    String? closingTime,
    double? consultationFee,
    int? averageConsultationTimeMinutes,
    int? maximumDailyPatients,
    bool? isQueueEnabled,
    bool? isBookingOpen,
    String? tokenPrefix,
  }) {
    return ClinicSettingsModel(
      id: id ?? this.id,
      clinicName: clinicName ?? this.clinicName,
      address: address ?? this.address,
      clinicAddress: clinicAddress ?? this.clinicAddress,
      contactNumber: contactNumber ?? this.contactNumber,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      maxTokensPerDoctor: maxTokensPerDoctor ?? this.maxTokensPerDoctor,
      openingTime: openingTime ?? this.openingTime,
      closingTime: closingTime ?? this.closingTime,
      consultationFee: consultationFee ?? this.consultationFee,
      averageConsultationTimeMinutes: averageConsultationTimeMinutes ?? this.averageConsultationTimeMinutes,
      maximumDailyPatients: maximumDailyPatients ?? this.maximumDailyPatients,
      isQueueEnabled: isQueueEnabled ?? this.isQueueEnabled,
      isBookingOpen: isBookingOpen ?? this.isBookingOpen,
      tokenPrefix: tokenPrefix ?? this.tokenPrefix,
    );
  }

  @override
  List<Object?> get props => [
        id,
        clinicName,
        address,
        clinicAddress,
        contactNumber,
        phoneNumber,
        email,
        maxTokensPerDoctor,
        openingTime,
        closingTime,
        consultationFee,
        averageConsultationTimeMinutes,
        maximumDailyPatients,
        isQueueEnabled,
        isBookingOpen,
        tokenPrefix,
      ];
}

