import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../widgets/dashboard_layout.dart';
import 'walk_in_dialog.dart';
import '../../providers/queue_provider.dart';
import '../../providers/notification_provider.dart';
import '../../models/queue_model.dart';
import '../../models/token_model.dart';
import 'package:intl/intl.dart';

class ReceptionDashboardScreen extends StatelessWidget {
  const ReceptionDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final queueProvider = Provider.of<QueueProvider>(context);
    final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
    
    final queue = queueProvider.liveQueue ?? QueueModel(id: 'mock', doctorId: 'mock', date: DateTime.now(), activeTokens: const []);
    final completedCount = queue.completedCount;
    final waitingCount = queue.waitingCount;
    final cancelledCount = queue.cancelledCount;
    final currentToken = queue.currentToken;
    
    return DashboardLayout(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Stats Bento
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 8,
                  child: Row(
                    children: [
                      Expanded(child: _buildStatCard(context, 'Completed', Icons.check_circle, '$completedCount', 'Today', colorScheme.tertiary)),
                      const SizedBox(width: 24),
                      Expanded(child: _buildStatCard(context, 'Waiting', Icons.hourglass_empty, '${waitingCount < 10 ? "0" : ""}$waitingCount', 'Est avg. wait: 8 mins', colorScheme.primary)),
                      const SizedBox(width: 24),
                      Expanded(child: _buildStatCard(context, 'Cancelled', Icons.cancel, '${cancelledCount < 10 ? "0" : ""}$cancelledCount', 'Today', colorScheme.error)),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                // Current Token Display
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('CURRENTLY SERVING', style: theme.textTheme.labelMedium?.copyWith(color: colorScheme.onPrimary.withValues(alpha: 0.8), letterSpacing: 2)),
                        const SizedBox(height: 16),
                        Text(currentToken != null ? '${currentToken.tokenNumber}' : '-', style: theme.textTheme.displayLarge?.copyWith(color: colorScheme.onPrimary, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(currentToken != null ? (currentToken.patientName ?? 'Unknown') : 'No Patient', style: theme.textTheme.titleLarge?.copyWith(color: colorScheme.onPrimary)),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Text('Room 03 • Dr. Baiju', style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onPrimary)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            // Queue Management Area
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorScheme.outlineVariant),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLow.withValues(alpha: 0.3),
                      border: Border(bottom: BorderSide(color: colorScheme.outlineVariant)),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Active Patient Queue', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                            Text('Manage and prioritize patient flow in real-time.', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
                          ],
                        ),
                        Row(
                          children: [
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorScheme.primary,
                                foregroundColor: colorScheme.onPrimary,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => Theme(
                                    data: AppTheme.dashboardTheme,
                                    child: const WalkInDialog(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.person_add),
                              label: const Text('New Walk-in'),
                            ),
                            const SizedBox(width: 8),
                            IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}, style: IconButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: colorScheme.outlineVariant)))),
                            const SizedBox(width: 8),
                            IconButton(icon: const Icon(Icons.refresh), onPressed: () {}, style: IconButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: colorScheme.outlineVariant)))),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Table Header
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    color: colorScheme.surfaceContainerLow,
                    child: Row(
                      children: [
                        Expanded(flex: 1, child: Text('TOKEN', style: _headerStyle(theme))),
                        Expanded(flex: 3, child: Text('PATIENT', style: _headerStyle(theme))),
                        Expanded(flex: 2, child: Text('PHONE', style: _headerStyle(theme))),
                        Expanded(flex: 2, child: Text('ARRIVAL', style: _headerStyle(theme))),
                        Expanded(flex: 2, child: Text('STATUS', style: _headerStyle(theme))),
                        Expanded(flex: 2, child: Align(alignment: Alignment.centerRight, child: Text('ACTIONS', style: _headerStyle(theme)))),
                      ],
                    ),
                  ),
                  
                  // Table Rows
                  if (queue.activeTokens.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(32),
                      child: Center(child: Text('No patients in queue yet', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant))),
                    ),
                  ...queue.activeTokens.map((token) {
                    final isWaiting = token.status == QueueStatus.waiting || token.status == QueueStatus.arrived;
                    final initials = token.patientName?.isNotEmpty == true ? token.patientName!.substring(0, 1).toUpperCase() : '?';
                    return _buildTableRow(
                      context: context,
                      token: '${token.tokenNumber}',
                      initials: initials,
                      name: token.patientName ?? 'Unknown',
                      dept: 'General Consultation',
                      phone: token.patientPhone ?? '-',
                      arrival: DateFormat('hh:mm a').format(token.issuedAt),
                      status: token.status.name.toUpperCase(),
                      isWaiting: isWaiting,
                      onCallNext: () => queueProvider.callNextPatient(notificationProvider),
                      onRecall: () => queueProvider.recallPatient(token.id, notificationProvider),
                      onSkip: () => queueProvider.skipPatient(token.id),
                      onCancel: () => queueProvider.cancelAppointment(token.id),
                      onComplete: () => queueProvider.completeConsultation(token.id),
                      onArrive: () => queueProvider.markPatientArrived(token.id),
                    );
                  }),
                  
                  // Footer
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLow.withValues(alpha: 0.3),
                      border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Showing ${queue.activeTokens.length} patients in queue', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
                        Row(
                          children: [
                            IconButton(icon: const Icon(Icons.chevron_left), onPressed: null, style: IconButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: colorScheme.outlineVariant)))),
                            const SizedBox(width: 8),
                            IconButton(icon: const Icon(Icons.chevron_right), onPressed: () {}, style: IconButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: colorScheme.outlineVariant)))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle? _headerStyle(ThemeData theme) {
    return theme.textTheme.labelMedium?.copyWith(
      fontWeight: FontWeight.bold,
      color: theme.colorScheme.onSurfaceVariant,
    );
  }

  Widget _buildStatCard(BuildContext context, String title, IconData icon, String value, String subtext, Color accentColor) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(top: BorderSide(color: accentColor, width: 4), left: BorderSide(color: colorScheme.outlineVariant), right: BorderSide(color: colorScheme.outlineVariant), bottom: BorderSide(color: colorScheme.outlineVariant)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: theme.textTheme.labelMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
              Icon(icon, color: accentColor),
            ],
          ),
          const SizedBox(height: 16),
          Text(value, style: theme.textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(subtext, style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }

  Widget _buildTableRow({
    required BuildContext context, 
    required String token, 
    required String initials, 
    required String name, 
    required String dept, 
    required String phone, 
    required String arrival, 
    required String status, 
    required bool isWaiting,
    required VoidCallback onCallNext,
    required VoidCallback onRecall,
    required VoidCallback onSkip,
    required VoidCallback onCancel,
    required VoidCallback onComplete,
    required VoidCallback onArrive,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(token, style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                CircleAvatar(backgroundColor: colorScheme.secondaryContainer, child: Text(initials, style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.onSecondaryContainer, fontWeight: FontWeight.bold))),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
                    Text(dept, style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                  ],
                ),
              ],
            ),
          ),
          Expanded(flex: 2, child: Text(phone, style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant))),
          Expanded(flex: 2, child: Text(arrival, style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant))),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                if (isWaiting) Container(width: 8, height: 8, margin: const EdgeInsets.only(right: 8), decoration: BoxDecoration(color: colorScheme.primary, shape: BoxShape.circle)),
                if (!isWaiting) Container(width: 8, height: 8, margin: const EdgeInsets.only(right: 8), decoration: BoxDecoration(color: colorScheme.outline, shape: BoxShape.circle)),
                Text(status, style: theme.textTheme.labelSmall?.copyWith(color: isWaiting ? colorScheme.primary : colorScheme.onSurfaceVariant, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (status == 'WAITING' || status == 'ARRIVED') 
                  IconButton(icon: Icon(Icons.volume_up, color: colorScheme.primary), onPressed: onCallNext, tooltip: 'Call Next'),
                if (status == 'CALLED')
                  IconButton(icon: Icon(Icons.replay, color: colorScheme.secondary), onPressed: onRecall, tooltip: 'Recall'),
                if (status == 'WAITING' || status == 'ARRIVED')
                  IconButton(icon: Icon(Icons.skip_next, color: colorScheme.onSurfaceVariant), onPressed: onSkip, tooltip: 'Skip'),
                if (status == 'INCONSULTATION')
                  IconButton(icon: Icon(Icons.check_circle, color: colorScheme.tertiary), onPressed: onComplete, tooltip: 'Complete'),
                if (status == 'BOOKED')
                  IconButton(icon: Icon(Icons.person_add, color: colorScheme.primary), onPressed: onArrive, tooltip: 'Mark Arrived'),
                const SizedBox(width: 8),
                IconButton(icon: Icon(Icons.delete_outline, color: colorScheme.error), onPressed: onCancel, tooltip: 'Cancel'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
