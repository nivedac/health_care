import 'package:equatable/equatable.dart';
import 'token_model.dart';

class QueueModel extends Equatable {
  final String id;
  final String doctorId;
  final DateTime date;
  final List<TokenModel> activeTokens;
  final TokenModel? currentToken;

  int get waitingCount => activeTokens.where((t) => t.status == QueueStatus.waiting || t.status == QueueStatus.arrived).length;
  int get completedCount => activeTokens.where((t) => t.status == QueueStatus.completed).length;
  int get cancelledCount => activeTokens.where((t) => t.status == QueueStatus.cancelled || t.status == QueueStatus.skipped).length;

  const QueueModel({
    required this.id,
    required this.doctorId,
    required this.date,
    required this.activeTokens,
    this.currentToken,
  });

  factory QueueModel.fromJson(Map<String, dynamic> json) {
    return QueueModel(
      id: json['id'] as String,
      doctorId: json['doctorId'] as String,
      date: DateTime.parse(json['date'] as String),
      activeTokens: (json['activeTokens'] as List<dynamic>)
          .map((e) => TokenModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentToken: json['currentToken'] != null
          ? TokenModel.fromJson(json['currentToken'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorId': doctorId,
      'date': '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
      'activeTokens': activeTokens.map((e) => e.toJson()).toList(),
      'currentToken': currentToken?.toJson(),
    };
  }

  QueueModel copyWith({
    String? id,
    String? doctorId,
    DateTime? date,
    List<TokenModel>? activeTokens,
    TokenModel? currentToken,
  }) {
    return QueueModel(
      id: id ?? this.id,
      doctorId: doctorId ?? this.doctorId,
      date: date ?? this.date,
      activeTokens: activeTokens ?? this.activeTokens,
      currentToken: currentToken ?? this.currentToken,
    );
  }

  @override
  List<Object?> get props => [id, doctorId, date, activeTokens, currentToken];
}
