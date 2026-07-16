import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/queue_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/queue_model.dart';

class LiveQueueScreen extends StatelessWidget {
  const LiveQueueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final authProvider = Provider.of<AuthProvider>(context);
    final queueProvider = Provider.of<QueueProvider>(context);
    
    final userPhone = authProvider.currentUser?.phoneNumber ?? '';
    final queue = queueProvider.liveQueue ?? QueueModel(id: 'mock', doctorId: 'mock', date: DateTime.now(), activeTokens: const []);

    final myToken = queue.activeTokens.cast<dynamic>().firstWhere(
      (t) => t.patientPhone == userPhone && (t.status.name == 'waiting' || t.status.name == 'booked' || t.status.name == 'arrived'),
      orElse: () => null,
    );

    final currentToken = queue.currentToken?.tokenNumber ?? 0;
    final yourToken = myToken?.tokenNumber ?? 0;
    
    final estWait = myToken != null ? queueProvider.getEstimatedWaitingTime(myToken.id) : 0;
    final patientsAhead = estWait ~/ QueueProvider.averageConsultationTime;
    
    // Calculate progress for circular indicator
    // E.g., if token is 24, and current is 18, maybe progress is 18/24
    final progress = yourToken > 0 && currentToken <= yourToken ? (currentToken / yourToken).clamp(0.0, 1.0) : 0.0;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface.withValues(alpha: 0.8),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurfaceVariant),
          onPressed: () => context.pop(),
        ),
        title: Text(
          "Dr. Baiju's Healthcare",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: colorScheme.onSurfaceVariant),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  children: [
                    // Header
                    Text(
                      'Live Queue Status',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'General Consultation - Room 3',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    // Circular Progress
                    Center(
                      child: Container(
                        width: 256,
                        height: 256,
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerLowest,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 40, offset: const Offset(0, 8)),
                          ],
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(
                                value: progress,
                                strokeWidth: 8,
                                strokeCap: StrokeCap.round,
                                backgroundColor: colorScheme.secondaryContainer,
                                color: colorScheme.primary,
                              ),
                            ),
                            Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('CURRENT TOKEN', style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.secondary)),
                                  const SizedBox(height: 4),
                                  Text('${currentToken > 0 ? currentToken : "-"}', style: theme.textTheme.displayMedium?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 8),
                                  Container(height: 1, width: 64, color: colorScheme.surfaceContainerHighest),
                                  const SizedBox(height: 8),
                                  Text('YOUR TOKEN', style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.secondary)),
                                  const SizedBox(height: 4),
                                  Text('${yourToken > 0 ? yourToken : "-"}', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    
                    // Details Grid
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerLowest.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.2)),
                              boxShadow: [
                                BoxShadow(color: colorScheme.primary.withValues(alpha: 0.05), blurRadius: 32, offset: const Offset(0, 8)),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: colorScheme.secondaryContainer,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.group, color: colorScheme.primary),
                                ),
                                const SizedBox(height: 12),
                                Text('$patientsAhead', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
                                const SizedBox(height: 4),
                                Text('Patients Ahead', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.secondary)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerLowest.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.2)),
                              boxShadow: [
                                BoxShadow(color: colorScheme.primary.withValues(alpha: 0.05), blurRadius: 32, offset: const Offset(0, 8)),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: colorScheme.secondaryContainer,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.schedule, color: colorScheme.primary),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text('$estWait', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
                                    Text('m', style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.onSurface)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text('Est. Waiting Time', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.secondary)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            // Actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.call, size: 20),
                          label: const Text('Call Clinic'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.directions, size: 20),
                          label: const Text('Directions'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.surfaceContainerLow,
                            foregroundColor: colorScheme.onSurface,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                            side: BorderSide(color: colorScheme.outlineVariant),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: myToken != null ? () {
                      queueProvider.cancelAppointment(myToken.id);
                      context.pop();
                    } : null,
                    child: Text('Cancel Booking', style: theme.textTheme.bodyMedium?.copyWith(color: myToken != null ? colorScheme.error : colorScheme.outlineVariant)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
