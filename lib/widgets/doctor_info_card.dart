import 'package:flutter/material.dart';

class DoctorInfoCard extends StatelessWidget {
  const DoctorInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.surfaceContainerHighest),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 40, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuAPcyBY-0K0RK34hZV8igjnb038ZckUJH3EZf27kRVtO9aSE9F-_0A_B42Byi9DkRHvD6urhkQtdc1h4Es2nojgLujRlPRgPxbO3ILKvyuSQDhPuSiB4m5PPIAIk1groK2o3LH6EIPOOc2nLLhfYk-1WtGZOtHBw8NmEJueLqCqWg9GRvMueHBIQBgvkxHY8jX1-trs4S4ccFX2TZmhhdqVhR4nlC_InfSlSan2e-cYUdSE9vX37nAYfHcw_9wA0_qtEUNfCylw8Q',
              width: 64,
              height: 64,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dr. Baiju', style: theme.textTheme.titleMedium),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.medical_services, size: 16, color: colorScheme.secondary),
                    const SizedBox(width: 4),
                    Text('General Physician', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.secondary)),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: colorScheme.tertiaryContainer.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Available Today 4:30 PM - 7:30 PM',
                    style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.tertiary),
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
