import 'package:equatable/equatable.dart';

class EmployeeModel extends Equatable {
  final String id;
  final String userId;
  final String name;
  final String position; // 'Receptionist', 'Admin', 'Nurse'
  final String department;
  final String? profileImageUrl;

  const EmployeeModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.position,
    required this.department,
    this.profileImageUrl,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      position: json['position'] as String,
      department: json['department'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
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
    };
  }

  EmployeeModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? position,
    String? department,
    String? profileImageUrl,
  }) {
    return EmployeeModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      position: position ?? this.position,
      department: department ?? this.department,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }

  @override
  List<Object?> get props => [id, userId, name, position, department, profileImageUrl];
}
