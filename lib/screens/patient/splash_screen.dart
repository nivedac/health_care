import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    // Auto navigate after 3.5 seconds
    Future.delayed(const Duration(milliseconds: 3500), () {
      if (mounted) {
        context.go('/login');
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          // Decorative Background Elements (Top Left)
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primaryContainer.withValues(alpha: 0.05),
                boxShadow: [
                  BoxShadow(color: colorScheme.primaryContainer.withValues(alpha: 0.05), blurRadius: 100),
                ],
              ),
            ),
          ),
          
          // Decorative Background Elements (Bottom Right)
          Positioned(
            bottom: -100,
            right: -100,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primaryContainer.withValues(alpha: 0.05),
                boxShadow: [
                  BoxShadow(color: colorScheme.primaryContainer.withValues(alpha: 0.05), blurRadius: 120),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo & Animation
                      FadeTransition(
                        opacity: _fadeController,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.2),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                            parent: _fadeController,
                            curve: Curves.easeOut,
                          )),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Pulse Ring 1
                              AnimatedBuilder(
                                animation: _pulseController,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: 0.95 + (_pulseController.value * 0.15),
                                    child: Opacity(
                                      opacity: math.max(0.0, 0.5 - (_pulseController.value * 0.5)),
                                      child: Container(
                                        width: 160,
                                        height: 160,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: colorScheme.primaryContainer,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              // Pulse Ring 2 (Delayed)
                              AnimatedBuilder(
                                animation: _pulseController,
                                builder: (context, child) {
                                  double val = (_pulseController.value + 0.5) % 1.0;
                                  return Transform.scale(
                                    scale: 0.95 + (val * 0.15),
                                    child: Opacity(
                                      opacity: math.max(0.0, 0.3 - (val * 0.3)),
                                      child: Container(
                                        width: 180,
                                        height: 180,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: colorScheme.primary.withValues(alpha: 0.3),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              
                              // Central Logo
                              Container(
                                width: 128,
                                height: 128,
                                decoration: BoxDecoration(
                                  color: colorScheme.surface,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: colorScheme.surfaceContainerHighest,
                                    width: 2,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 30,
                                      offset: Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.favorite,
                                  size: 64,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Typography
                      FadeTransition(
                        opacity: CurvedAnimation(
                          parent: _fadeController,
                          curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
                        ),
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.2),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                            parent: _fadeController,
                            curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
                          )),
                          child: Column(
                            children: [
                              Text(
                                "Dr. Baiju's Healthcare",
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onSurface,
                                  letterSpacing: -0.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Smart Clinic Management",
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: colorScheme.secondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Footer
                FadeTransition(
                  opacity: CurvedAnimation(
                    parent: _fadeController,
                    curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
                  ),
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.2),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: _fadeController,
                      curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
                    )),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "POWERED BY",
                            style: theme.textTheme.labelSmall?.copyWith(
                              letterSpacing: 1.5,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.medical_services,
                                size: 16,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Dr. Baiju's Healthcare",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
