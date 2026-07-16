import 'package:equatable/equatable.dart';

class HolidayModel extends Equatable {
  final String id;
  final DateTime date;
  final String name;
  final String? description;
  final bool disableBooking;

  const HolidayModel({
    required this.id,
    required this.date,
    required this.name,
    this.description,
    this.disableBooking = true,
  });

  factory HolidayModel.fromJson(Map<String, dynamic> json) {
    return HolidayModel(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      name: json['name'] as String,
      description: json['description'] as String?,
      disableBooking: json['disableBooking'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'name': name,
      'description': description,
      'disableBooking': disableBooking,
    };
  }

  HolidayModel copyWith({
    String? id,
    DateTime? date,
    String? name,
    String? description,
    bool? disableBooking,
  }) {
    return HolidayModel(
      id: id ?? this.id,
      date: date ?? this.date,
      name: name ?? this.name,
      description: description ?? this.description,
      disableBooking: disableBooking ?? this.disableBooking,
    );
  }

  @override
  List<Object?> get props => [id, date, name, description, disableBooking];
}
