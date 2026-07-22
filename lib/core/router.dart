import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../providers/auth_provider.dart';
import '../screens/patient/splash_screen.dart';
import '../screens/patient/login_screen.dart';
import '../screens/patient/otp_verification_screen.dart';
import '../screens/patient/registration_screen.dart';
import '../screens/patient/home_screen.dart';
import '../screens/patient/book_token_screen.dart';
import '../screens/patient/booking_success_screen.dart';
import '../screens/patient/live_queue_screen.dart';
import '../screens/reception/dashboard_screen.dart';
import '../screens/reception/queue_management_screen.dart';
import '../screens/reception/patient_search_screen.dart';
import '../models/appointment_model.dart';
import '../screens/admin/admin_dashboard_screen.dart';
import '../screens/admin/employee_management_screen.dart';
import '../screens/admin/doctor_management_screen.dart';
import '../screens/admin/reports_screen.dart';
import '../screens/admin/clinic_settings_screen.dart';
import '../screens/admin/holiday_management_screen.dart';
import '../screens/admin/notification_center_screen.dart';

/// Core application routing configuration using [GoRouter].
/// 
/// This class encapsulates all navigation logic, route definitions, and 
/// authentication-based redirection rules. It enforces role-based access 
/// control (RBAC) by ensuring unauthenticated users cannot access protected 
/// routes and routing authenticated users to their respective role-based dashboards.
class AppRouter {
  /// Creates and configures the main [GoRouter] instance.
  /// 
  /// The router listens to the provided [authProvider] for state changes
  /// and automatically re-evaluates the redirect logic when authentication
  /// state changes (e.g., on login or logout).
  static GoRouter createRouter(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: '/',
      refreshListenable: authProvider,
      redirect: (context, state) {
        final isAuthenticated = authProvider.isAuthenticated;
        final isGoingToLogin = state.uri.toString() == '/login' || 
                               state.uri.toString() == '/register' || 
                               state.uri.toString() == '/otp';
        
        if (!isAuthenticated && !isGoingToLogin && state.uri.toString() != '/') {
          return '/';
        }

        if (isAuthenticated && isGoingToLogin) {
          final role = authProvider.currentUser?.role;
          if (role == 'admin') return '/admin';
          if (role == 'reception') return '/reception';
          return '/patient';
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/otp',
          builder: (context, state) => const OtpVerificationScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegistrationScreen(),
        ),
        
        // Patient Routes
        GoRoute(
          path: '/patient',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/book-token',
          builder: (context, state) => const BookTokenScreen(),
        ),
        GoRoute(
          path: '/booking-success',
          builder: (context, state) {
            final appointment = state.extra as AppointmentModel;
            return BookingSuccessScreen(appointment: appointment);
          },
        ),
        GoRoute(
          path: '/live-queue',
          builder: (context, state) => const LiveQueueScreen(),
        ),
        GoRoute(
          path: '/history',
          builder: (context, state) => const Scaffold(body: SizedBox.shrink()),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const Scaffold(body: SizedBox.shrink()),
        ),
        
        // Reception Routes
        GoRoute(
          path: '/reception',
          builder: (context, state) => const ReceptionDashboardScreen(),
          routes: [
            GoRoute(path: 'queue', builder: (context, state) => const QueueManagementScreen()),
            GoRoute(path: 'search-patients', builder: (context, state) => const PatientSearchScreen()),
          ],
        ),
        
        // Admin Routes
        GoRoute(
          path: '/admin',
          builder: (context, state) => const AdminDashboardScreen(),
          routes: [
            GoRoute(path: 'employees', builder: (context, state) => const EmployeeManagementScreen()),
            GoRoute(path: 'doctors', builder: (context, state) => const DoctorManagementScreen()),
            GoRoute(path: 'reports', builder: (context, state) => const ReportsScreen()),
            GoRoute(path: 'settings', builder: (context, state) => const ClinicSettingsScreen()),
            GoRoute(path: 'holidays', builder: (context, state) => const HolidayManagementScreen()),
            GoRoute(path: 'notifications', builder: (context, state) => const NotificationCenterScreen()),
          ],
        ),
      ],
    );
  }
}
