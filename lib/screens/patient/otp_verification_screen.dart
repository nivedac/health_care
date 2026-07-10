import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/buttons.dart';
import '../../widgets/inputs.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({Key? key}) : super(key: key);

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  int _timeLeft = 119;
  bool _isVerifying = false;

  void _onVerify() async {
    setState(() {
      _isVerifying = true;
    });
    
    // Simulate verification delay
    await Future.delayed(const Duration(seconds: 1));
    
    if (mounted) {
      setState(() {
        _isVerifying = false;
      });
      // The router config has auth logic. Since we haven't actually logged in 
      // the authProvider during OTP, we'll assume it's mock flow and navigate.
      // But typically we should call authProvider.verifyOtp() here.
      // For now, navigate to home (or registration if new user).
      context.go('/patient');
    }
  }

  void _onResend() {
    // Mock resend
    setState(() {
      _timeLeft = 119;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final minutes = (_timeLeft / 60).floor();
    final seconds = _timeLeft % 60;
    final timerString = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          // Ambient Backgrounds
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.width * 0.6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primaryContainer.withOpacity(0.1),
                boxShadow: [
                  BoxShadow(color: colorScheme.primaryContainer.withOpacity(0.1), blurRadius: 100),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -50,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.width * 0.7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.secondaryContainer.withOpacity(0.15),
                boxShadow: [
                  BoxShadow(color: colorScheme.secondaryContainer.withOpacity(0.15), blurRadius: 120),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Floating Back Button
                Padding(
                  padding: const EdgeInsets.only(left: 24.0, top: 16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => context.pop(),
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
                
                const Spacer(),
                
                // Verification Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 40,
                          offset: const Offset(0, 20),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Top accent line
                        Container(
                          height: 4,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [colorScheme.primary, colorScheme.primaryContainer],
                            ),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Header
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.shield, color: colorScheme.primary, size: 36),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Verification Code',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "We've sent a verification code to your mobile.",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // OTP Input Group
                        const OTPField(length: 6),
                        
                        const SizedBox(height: 32),
                        
                        // Timer
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.schedule, color: colorScheme.secondary, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              timerString,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.secondary,
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Actions
                        PrimaryButton(
                          label: 'Verify',
                          isLoading: _isVerifying,
                          onPressed: _onVerify,
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: TextButton(
                            onPressed: _onResend,
                            style: TextButton.styleFrom(
                              backgroundColor: colorScheme.surfaceContainerHighest,
                              foregroundColor: colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: const Text(
                              'Resend OTP',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const Spacer(flex: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
