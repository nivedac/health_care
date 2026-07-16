import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/appointment_provider.dart';
import '../../providers/queue_provider.dart';
import '../../models/appointment_model.dart';
import '../../widgets/doctor_info_card.dart';

class BookTokenScreen extends StatelessWidget {
  const BookTokenScreen({super.key});

  void _showConfirmationDialog(BuildContext context, AppointmentProvider appointmentProvider, QueueProvider queueProvider, String userId, String userName, String userPhone) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Booking'),
        content: const Text('Do you want to book a token for General Consultation with Dr. Baiju?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              
              // Mock generating an appointment
              final newAppointment = AppointmentModel(
                id: 'mock_appt_${DateTime.now().millisecondsSinceEpoch}',
                patientId: userId,
                doctorId: 'mock_doctor_baiju',
                appointmentDate: DateTime.now(),
                tokenNumber: 24, // Fallback, but we use queue provider for actual queueing
                estimatedTime: DateTime.now().add(const Duration(minutes: 45)),
                status: 'scheduled',
              );
              
              await appointmentProvider.bookAppointment(newAppointment);
              
              // Also add to queue workflow
              queueProvider.generateToken(patientName: userName, patientPhone: userPhone, patientId: userId);
              
              if (context.mounted) {
                context.push('/booking-success', extra: newAppointment);
              }
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final authProvider = Provider.of<AuthProvider>(context);
    final appointmentProvider = Provider.of<AppointmentProvider>(context, listen: false);
    final queueProvider = Provider.of<QueueProvider>(context, listen: false);
    final user = authProvider.currentUser;

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
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundImage: const NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuAeNJCeWpV4Z0m4WnF8jYs0xb2TCNWUzLnP_A1mnOBpdxiMvP8cKF0baK1WDyeaPA1PupUE5rnNHu9sjO2lDpI0-As01ICeP0vTjl6uI6FHNUPX2ukZWJGyVen5P_8WdIyXOMHG670IPvCeLBiX9UkHKHlC3WM2b6tlS2-Q1i-h5PA5nF7Z8bZ77Q0lDk8r_Ba5Qua4R1nMXE0KVRPqVuBX5oCFW8Cccmi1txgFvwHZusC6GwcrlVGWMpcKJN__IkbUWlgNMRr-aw'),
              radius: 18,
              backgroundColor: colorScheme.surfaceContainerHighest,
            ),
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Doctor Info Card
                    const DoctorInfoCard(),
                    const SizedBox(height: 24),
                    
                    Text('Booking Details', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 16),
                    
                    // Booking Details Grid
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.2,
                      children: [
                        _buildDetailCard(
                          context: context,
                          title: 'Appointment Type',
                          value: 'General Consultation',
                          icon: Icons.medical_services,
                          color: colorScheme.secondary,
                        ),
                        _buildDetailCard(
                          context: context,
                          title: 'Estimated Waiting',
                          value: '45 mins',
                          icon: Icons.hourglass_empty,
                          color: colorScheme.error,
                        ),
                        _buildDetailCard(
                          context: context,
                          title: 'Approx Consultation',
                          value: '15 mins',
                          icon: Icons.timer,
                          color: colorScheme.tertiary,
                        ),
                        _buildDetailCard(
                          context: context,
                          title: 'Available Tokens',
                          value: '12 slots left',
                          icon: Icons.confirmation_number,
                          color: colorScheme.primary,
                          isPrimary: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Patient Selection Mock
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: colorScheme.surfaceContainerHighest),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 40, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Patient Details', style: theme.textTheme.titleMedium),
                              TextButton(
                                onPressed: () {},
                                child: const Text('Change'),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceBright,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: colorScheme.secondaryContainer,
                                  foregroundColor: colorScheme.onSecondaryContainer,
                                  child: Text(user?.name.substring(0, 2).toUpperCase() ?? 'JD'),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(user?.name ?? 'John Doe', style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500)),
                                      Text('Self • 32 Yrs', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
                                    ],
                                  ),
                                ),
                                Icon(Icons.check_circle, color: colorScheme.primary),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Bottom Action Area
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: colorScheme.surface.withValues(alpha: 0.9),
                border: Border(top: BorderSide(color: colorScheme.surfaceContainerHighest)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Consultation Fee', style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                      Text('₹500', style: theme.textTheme.titleLarge),
                    ],
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                    ),
                    onPressed: () => _showConfirmationDialog(context, appointmentProvider, queueProvider, user?.id ?? 'mock_user_id', user?.name ?? 'Guest', user?.phoneNumber ?? ''),
                    label: const Text('Book Now'),
                    iconAlignment: IconAlignment.end,
                    icon: const Icon(Icons.arrow_forward, size: 20),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    bool isPrimary = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isPrimary ? colorScheme.primaryContainer : colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: isPrimary ? null : Border.all(color: colorScheme.surfaceContainerHighest),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 40, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isPrimary ? Colors.white.withValues(alpha: 0.2) : color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: isPrimary ? colorScheme.onPrimaryContainer : color, size: 20),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title, 
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isPrimary ? colorScheme.onPrimaryContainer.withValues(alpha: 0.8) : colorScheme.onSurfaceVariant,
                  fontSize: 10,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                value, 
                style: theme.textTheme.titleMedium?.copyWith(
                  color: isPrimary ? colorScheme.onPrimaryContainer : colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
