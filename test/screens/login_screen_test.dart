import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:baijus/screens/patient/login_screen.dart';
import 'package:baijus/providers/auth_provider.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:go_router/go_router.dart';

import 'login_screen_test.mocks.dart';

@GenerateMocks([AuthProvider])
void main() {
  late MockAuthProvider mockAuthProvider;

  setUp(() {
    mockAuthProvider = MockAuthProvider();
    when(mockAuthProvider.isLoading).thenReturn(false);
  });

  Widget createTestWidget() {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Scaffold(body: LoginScreen()),
        ),
        GoRoute(
          path: '/otp',
          builder: (context, state) => const Scaffold(body: Text('OTP Screen')),
        ),
      ],
    );

    return ChangeNotifierProvider<AuthProvider>.value(
      value: mockAuthProvider,
      child: MaterialApp.router(
        routerConfig: router,
      ),
    );
  }

  testWidgets('Validation: requires 10 digits', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());
    
    // Check initial state
    expect(find.byType(LoginScreen), findsOneWidget);

    // Enter invalid number
    await tester.enterText(find.byType(TextFormField).first, '12345');
    await tester.tap(find.byType(Checkbox).first); // Agree to terms
    await tester.pumpAndSettle();
    
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    
    // Check validation error
    expect(find.text('Enter a valid 10-digit mobile number'), findsOneWidget);
    verifyNever(mockAuthProvider.login(any, any));
  });

  testWidgets('Validation: triggers OTP with +91 format and handles duplicate +91', (WidgetTester tester) async {
    when(mockAuthProvider.login(any, any)).thenAnswer((_) async => true);
    
    await tester.pumpWidget(createTestWidget());

    // Enter duplicate country code
    await tester.enterText(find.byType(TextFormField).first, '+919876543210');
    await tester.tap(find.byType(Checkbox).first); // Agree to terms
    await tester.pumpAndSettle();
    
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    
    // Verify login is called with correct formatted number
    verify(mockAuthProvider.login('+919876543210', '')).called(1);
  });
  
  testWidgets('Validation: triggers OTP with normal 10 digits', (WidgetTester tester) async {
    when(mockAuthProvider.login(any, any)).thenAnswer((_) async => true);
    
    await tester.pumpWidget(createTestWidget());

    // Enter normal number
    await tester.enterText(find.byType(TextFormField).first, '9876543210');
    await tester.tap(find.byType(Checkbox).first); // Agree to terms
    await tester.pumpAndSettle();
    
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    
    // Verify login is called with prepended +91
    verify(mockAuthProvider.login('+919876543210', '')).called(1);
  });
}
