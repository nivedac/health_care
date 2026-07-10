import 'package:equatable/equatable.dart';

class DoctorModel extends Equatable {
  final String id;
  final String userId;
  final String name; // duplicated for easy access
  final String specialization;
  final String? profileImageUrl;
  final bool isAvailable;

  const DoctorModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.specialization,
    this.profileImageUrl,
    this.isAvailable = true,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      specialization: json['specialization'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      isAvailable: json['isAvailable'] as bool? ?? true,
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
    };
  }

  DoctorModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? specialization,
    String? profileImageUrl,
    bool? isAvailable,
  }) {
    return DoctorModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      specialization: specialization ?? this.specialization,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }

  @override
  List<Object?> get props => [id, userId, name, specialization, profileImageUrl, isAvailable];
}
