import 'package:equatable/equatable.dart';

class DoctorModel extends Equatable {
  final String id;
  final String userId;
  final String name; // duplicated for easy access
  final String specialization;
  final String? profileImageUrl;
  final bool isAvailable;
  
  // New Admin Fields
  final String qualification;
  final String experience;
  final double consultationFee;
  final List<String> availableDays;
  final String startTime;
  final String endTime;

  const DoctorModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.specialization,
    this.profileImageUrl,
    this.isAvailable = true,
    this.qualification = 'MBBS, MD',
    this.experience = '10 Years',
    this.consultationFee = 500.0,
    this.availableDays = const ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
    this.startTime = '09:00 AM',
    this.endTime = '05:00 PM',
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      specialization: json['specialization'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      isAvailable: json['isAvailable'] as bool? ?? true,
      qualification: json['qualification'] as String? ?? '',
      experience: json['experience'] as String? ?? '',
      consultationFee: (json['consultationFee'] as num?)?.toDouble() ?? 500.0,
      availableDays: (json['availableDays'] as List<dynamic>?)?.cast<String>() ?? const [],
      startTime: json['startTime'] as String? ?? '09:00 AM',
      endTime: json['endTime'] as String? ?? '05:00 PM',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'specialization': specialization,
      'profileImageUrl': profileImageUrl,
      'isAvailable': isAvailable,
      'qualification': qualification,
      'experience': experience,
      'consultationFee': consultationFee,
      'availableDays': availableDays,
      'startTime': startTime,
      'endTime': endTime,
    };
  }

  DoctorModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? specialization,
    String? profileImageUrl,
    bool? isAvailable,
    String? qualification,
    String? experience,
    double? consultationFee,
    List<String>? availableDays,
    String? startTime,
    String? endTime,
  }) {
    return DoctorModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      specialization: specialization ?? this.specialization,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isAvailable: isAvailable ?? this.isAvailable,
      qualification: qualification ?? this.qualification,
      experience: experience ?? this.experience,
      consultationFee: consultationFee ?? this.consultationFee,
      availableDays: availableDays ?? this.availableDays,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  @override
  List<Object?> get props => [id, userId, name, specialization, profileImageUrl, isAvailable, qualification, experience, consultationFee, availableDays, startTime, endTime];
}
