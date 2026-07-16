import 'package:mockito/annotations.dart';
import 'package:baijus/repositories/queue_repository.dart';
import 'package:baijus/repositories/appointment_repository.dart';
import 'package:baijus/repositories/auth_repository.dart';
import 'package:baijus/repositories/notification_repository.dart';
import 'package:baijus/providers/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@GenerateMocks([
  QueueRepository,
  AppointmentRepository,
  AuthRepository,
  NotificationRepository,
  AuthProvider,
  FirebaseFirestore,
])
void main() {}
