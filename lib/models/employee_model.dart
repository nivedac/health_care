import 'package:equatable/equatable.dart';

class EmployeeModel extends Equatable {
  final String id;
  final String userId;
  final String name;
  final String position; // 'Receptionist', 'Admin', 'Nurse'
  final String department;
  final String? profileImageUrl;
  final String? phone;
  final String? email;
  final bool isActive;

  const EmployeeModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.position,
    required this.department,
    this.profileImageUrl,
    this.phone,
    this.email,
    this.isActive = true,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      position: json['position'] as String,
      department: json['department'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'position': position,
      'department': department,
      'profileImageUrl': profileImageUrl,
      'phone': phone,
      'email': email,
      'isActive': isActive,
    };
  }

  EmployeeModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? position,
    String? department,
    String? profileImageUrl,
    String? phone,
    String? email,
    bool? isActive,
  }) {
    return EmployeeModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      position: position ?? this.position,
      department: department ?? this.department,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [id, userId, name, position, department, profileImageUrl, phone, email, isActive];
}
