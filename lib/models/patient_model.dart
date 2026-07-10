import 'package:equatable/equatable.dart';

class PatientModel extends Equatable {
  final String id;
  final String userId;
  final String? fullName;
  final String? phoneNumber;
  final int? age;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? bloodGroup;
  final String? address;

  const PatientModel({
    required this.id,
    required this.userId,
    this.fullName,
    this.phoneNumber,
    this.age,
    this.dateOfBirth,
    this.gender,
    this.bloodGroup,
    this.address,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      fullName: json['fullName'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      age: json['age'] as int?,
      dateOfBirth: json['dateOfBirth'] != null ? DateTime.parse(json['dateOfBirth'] as String) : null,
      gender: json['gender'] as String?,
      bloodGroup: json['bloodGroup'] as String?,
      address: json['address'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'age': age,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'bloodGroup': bloodGroup,
      'address': address,
    };
  }

  PatientModel copyWith({
    String? id,
    String? userId,
    String? fullName,
    String? phoneNumber,
    int? age,
    DateTime? dateOfBirth,
    String? gender,
    String? bloodGroup,
    String? address,
  }) {
    return PatientModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      age: age ?? this.age,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      address: address ?? this.address,
    );
  }

  @override
  List<Object?> get props => [id, userId, fullName, phoneNumber, age, dateOfBirth, gender, bloodGroup, address];
}
