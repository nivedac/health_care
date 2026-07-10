import 'package:flutter/material.dart';
import 'reception_layout.dart';

class QueueManagementScreen extends StatelessWidget {
  const QueueManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // We will consume QueueProvider later if needed
    // For now we just implement the UI exactly.

    return ReceptionLayout(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Quick Actions & Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Live Queue Management',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Real-time patient flow for Room 302 - General Medicine',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.error,
                        foregroundColor: colorScheme.onError,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.emergency),
                      label: const Text('New Emergency', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.person_add),
                      label: const Text('New Walk-in', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            // Main Dashboard Grid
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left: Focused Current Token
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: colorScheme.outlineVariant),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12, offset: const Offset(0, 4)),
                          ],
                        ),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: colorScheme.tertiaryContainer,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  'Now Serving',
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: colorScheme.onTertiaryContainer,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'CURRENT TOKEN',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                            Text(
                              'A-124',
                              style: theme.textTheme.displayMedium?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            CircleAvatar(
                              radius: 48,
                              backgroundColor: colorScheme.surfaceContainer,
                              child: Icon(Icons.person, size: 48, color: colorScheme.onSurfaceVariant),
                            ),
                            const SizedBox(height: 16),
                            Text('Robert Patterson', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                            Text('+1 (555) 012-3456', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Chip(label: const Text('Age: 68'), backgroundColor: colorScheme.surfaceContainer),
                                const SizedBox(width: 8),
                                Chip(label: const Text('Regular Checkup'), backgroundColor: colorScheme.surfaceContainer),
                              ],
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colorScheme.primary,
                                  foregroundColor: colorScheme.onPrimary,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: () {},
                                icon: const Icon(Icons.check_circle),
                                label: const Text('Complete Visit', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: colorScheme.surfaceContainerLow,
                                      foregroundColor: colorScheme.primary,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    onPressed: () {},
                                    icon: const Icon(Icons.campaign),
                                    label: const Text('Call Again', style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: colorScheme.surfaceContainerLow,
                                      foregroundColor: colorScheme.error,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    onPressed: () {},
                                    icon: const Icon(Icons.block),
                                    label: const Text('No Show', style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                // Right: Full Waiting List
                Expanded(
                  flex: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colorScheme.outlineVariant),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceBright,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            border: Border(bottom: BorderSide(color: colorScheme.outlineVariant)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text('Waiting List', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                                  const SizedBox(width: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: colorScheme.primaryContainer.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      '8 Waiting',
                                      style: theme.textTheme.labelMedium?.copyWith(
                                        color: colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  TextButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(Icons.filter_list),
                                    label: const Text('Filter'),
                                    style: TextButton.styleFrom(foregroundColor: colorScheme.onSurfaceVariant),
                                  ),
                                  TextButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(Icons.sort),
                                    label: const Text('Sort'),
                                    style: TextButton.styleFrom(foregroundColor: colorScheme.onSurfaceVariant),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Patient Row
                        _buildPatientRow(context, 'A-125', 'Priority', 'Amanda Collins', 'ID: 8829-X • Allergy: Penicillin', '04m', colorScheme.error, true),
                        const Divider(height: 1),
                        _buildPatientRow(context, 'A-126', 'Waiting', 'Daniel Martinez', 'ID: 4421-M • Follow-up Visit', '18m', colorScheme.onSurface, false),
                        const Divider(height: 1),
                        _buildPatientRow(context, 'A-127', 'Waiting', 'Liam Henderson', 'ID: 1092-L • New Patient Intake', '25m', colorScheme.onSurface, false),
                        const Divider(height: 1),
                        _buildPatientRow(context, 'B-004', 'Walk-in', 'Sophie Turner', 'ID: 7210-S • Acute Symptom Review', '32m', colorScheme.secondary, false),
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
                          ),
                          child: Center(
                            child: TextButton.icon(
                              onPressed: () {},
                              icon: const Text('View All 8 Waiting Patients'),
                              label: const Icon(Icons.arrow_downward, size: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientRow(BuildContext context, String token, String status, String name, String details, String waitTime, Color statusColor, bool isPriority) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          SizedBox(
            width: 64,
            child: Column(
              children: [
                Text(token, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: statusColor)),
                Text(status.toUpperCase(), style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, color: statusColor)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          CircleAvatar(
            backgroundColor: colorScheme.surfaceContainer,
            child: Icon(Icons.person, color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                Text(details, style: theme.textTheme.labelMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          SizedBox(
            width: 128,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Wait Time', style: theme.textTheme.labelMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
                Text(waitTime, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.campaign, color: colorScheme.primary),
                onPressed: () {},
                tooltip: 'Call Patient',
              ),
              IconButton(
                icon: Icon(Icons.fast_forward, color: colorScheme.secondary),
                onPressed: () {},
                tooltip: 'Skip Patient',
              ),
              IconButton(
                icon: Icon(Icons.check_circle, color: colorScheme.tertiary),
                onPressed: () {},
                tooltip: 'Mark Complete',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
