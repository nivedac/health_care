import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/appointment_provider.dart';
import '../../providers/queue_provider.dart';
import '../../providers/settings_provider.dart';
import '../../models/token_model.dart';
import '../../widgets/doctor_info_card.dart';
import 'package:uuid/uuid.dart';

class BookTokenScreen extends StatefulWidget {
  const BookTokenScreen({super.key});

  @override
  State<BookTokenScreen> createState() => _BookTokenScreenState();
}

class _BookTokenScreenState extends State<BookTokenScreen> {
  /// The doctor ID to book with.
  /// TODO: In Phase 4 this will be passed as a route parameter.
  static const String _doctorId = 'dr_baiju_mb';

  @override
  void initState() {
    super.initState();
    // Fetch latest settings so isBookingOpen is current
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SettingsProvider>(context, listen: false).fetchSettings();
    });
  }

  Future<void> _handleBookNow(
    BuildContext context,
    AppointmentProvider appointmentProvider,
    QueueProvider queueProvider,
    SettingsProvider settingsProvider,
    String userId,
    String userName,
    String? userPhone,
  ) async {
    // ---- Layer 1: Client-side open/close check (UI validation)
    // ---- Layer 2: Repository check inside bookAppointmentTransactionally
    // ---- Layer 3: Firestore Security Rules (server-side — isBookingOpen via get())
    final isBookingOpen = settingsProvider.settings?.isBookingOpen ?? true;
    if (!isBookingOpen) {
      if (!context.mounted) return;
      _showErrorDialog(
        context,
        'Booking Closed',
        'Booking is currently closed by the clinic. Please contact reception or try again later.',
      );
      return;
    }

    final confirmed = await _showConfirmationDialog(context, settingsProvider);
    if (!confirmed || !context.mounted) return;

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final result = await appointmentProvider.bookAppointment(
      patientId: userId,
      patientName: userName,
      patientPhone: userPhone,
      doctorId: _doctorId,
      appointmentDate: DateTime.now(),
    );

    if (!context.mounted) return;
    Navigator.of(context).pop(); // Close loading dialog

    if (result == null) {
      // bookAppointment returned null → check lastBookingError
      final error = appointmentProvider.lastBookingError ??
          'Booking failed. Please try again.';
      _showErrorDialog(context, 'Booking Failed', error);
      appointmentProvider.clearError();
      return;
    }

    // Add token to live queue if queue is open today
    if (queueProvider.liveQueue != null) {
      final token = TokenModel(
        id: const Uuid().v4(),
        appointmentId: result.appointmentId,
        tokenNumber: result.tokenNumber,
        issuedAt: DateTime.now(),
        status: QueueStatus.booked,
        patientId: userId,
        patientName: userName,
        patientPhone: userPhone,
      );
      await queueProvider.addTokenToQueue(token);
    }

    if (!context.mounted) return;

    // Navigate to success screen
    // Pass a minimal appointment map for the success screen to display
    context.push('/booking-success', extra: {
      'appointmentId': result.appointmentId,
      'tokenNumber': result.tokenNumber,
      'doctorName': 'Dr. Baiju MB',
      'patientName': userName,
    });
  }

  Future<bool> _showConfirmationDialog(
    BuildContext context,
    SettingsProvider settingsProvider,
  ) async {
    final fee = settingsProvider.settings?.consultationFee ?? 500.0;
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Booking'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
                'Book a token for General Consultation with Dr. Baiju MB?'),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.currency_rupee, size: 16),
                Text(
                  'Consultation fee: ₹${fee.toStringAsFixed(0)}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
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
    final appointmentProvider =
        Provider.of<AppointmentProvider>(context, listen: false);
    final queueProvider = Provider.of<QueueProvider>(context, listen: false);
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final user = authProvider.currentUser;

    final isBookingOpen = settingsProvider.settings?.isBookingOpen ?? true;
    final consultationFee =
        settingsProvider.settings?.consultationFee ?? 500.0;

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
              radius: 18,
              backgroundColor: colorScheme.surfaceContainerHighest,
              backgroundImage:
                  user?.profileImageUrl != null
                      ? NetworkImage(user!.profileImageUrl!)
                      : null,
              child: user?.profileImageUrl == null
                  ? Icon(Icons.person,
                      size: 18, color: colorScheme.onSurfaceVariant)
                  : null,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Doctor Info Card
                    const DoctorInfoCard(),
                    const SizedBox(height: 24),

                    // Booking Closed Banner (shown when admin has closed bookings)
                    if (!isBookingOpen)
                      Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.block,
                                color: colorScheme.onErrorContainer),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Booking is currently closed. Please contact the reception.',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onErrorContainer),
                              ),
                            ),
                          ],
                        ),
                      ),

                    Text('Booking Details',
                        style: theme.textTheme.titleMedium),
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
                          title: 'Consultation Type',
                          value: 'General / Diabetes',
                          icon: Icons.medical_services,
                          color: colorScheme.secondary,
                        ),
                        _buildDetailCard(
                          context: context,
                          title: 'Avg Wait/Patient',
                          value: '~8 mins',
                          icon: Icons.hourglass_empty,
                          color: colorScheme.error,
                        ),
                        _buildDetailCard(
                          context: context,
                          title: 'Clinic Hours',
                          value: '4:30–7:30 PM',
                          icon: Icons.access_time,
                          color: colorScheme.tertiary,
                        ),
                        _buildDetailCard(
                          context: context,
                          title: 'Booking Status',
                          value: isBookingOpen ? 'Open' : 'Closed',
                          icon: isBookingOpen
                              ? Icons.confirmation_number
                              : Icons.block,
                          color: isBookingOpen
                              ? colorScheme.primary
                              : colorScheme.error,
                          isPrimary: isBookingOpen,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Patient Details
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: colorScheme.surfaceContainerHighest),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 40,
                              offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Patient Details',
                                  style: theme.textTheme.titleMedium),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceBright,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: colorScheme.outlineVariant
                                      .withValues(alpha: 0.5)),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                      colorScheme.secondaryContainer,
                                  foregroundColor:
                                      colorScheme.onSecondaryContainer,
                                  child: Text(user?.name
                                          .substring(0, 2)
                                          .toUpperCase() ??
                                      'JD'),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user?.name ?? 'Guest',
                                        style: theme.textTheme.bodyLarge
                                            ?.copyWith(
                                                fontWeight: FontWeight.w500),
                                      ),
                                      if (user?.phoneNumber != null)
                                        Text(
                                          user!.phoneNumber!,
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                  color: colorScheme
                                                      .onSurfaceVariant),
                                        ),
                                    ],
                                  ),
                                ),
                                Icon(Icons.check_circle,
                                    color: colorScheme.primary),
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: colorScheme.surface.withValues(alpha: 0.9),
                border: Border(
                    top: BorderSide(
                        color: colorScheme.surfaceContainerHighest)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Consultation Fee',
                        style: theme.textTheme.labelSmall
                            ?.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                      Text(
                        '₹${consultationFee.toStringAsFixed(0)}',
                        style: theme.textTheme.titleLarge,
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isBookingOpen
                          ? colorScheme.primary
                          : colorScheme.surfaceContainerHighest,
                      foregroundColor: isBookingOpen
                          ? colorScheme.onPrimary
                          : colorScheme.onSurfaceVariant,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                    ),
                    onPressed: isBookingOpen
                        ? () => _handleBookNow(
                              context,
                              appointmentProvider,
                              queueProvider,
                              settingsProvider,
                              user?.id ?? '',
                              user?.name ?? 'Guest',
                              user?.phoneNumber,
                            )
                        : null,
                    label: Text(isBookingOpen ? 'Book Now' : 'Booking Closed'),
                    iconAlignment: IconAlignment.end,
                    icon: Icon(
                      isBookingOpen ? Icons.arrow_forward : Icons.lock,
                      size: 20,
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
        color: isPrimary
            ? colorScheme.primaryContainer
            : colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: isPrimary
            ? null
            : Border.all(color: colorScheme.surfaceContainerHighest),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 40,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isPrimary
                  ? Colors.white.withValues(alpha: 0.2)
                  : color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon,
                color: isPrimary ? colorScheme.onPrimaryContainer : color,
                size: 20),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isPrimary
                      ? colorScheme.onPrimaryContainer.withValues(alpha: 0.8)
                      : colorScheme.onSurfaceVariant,
                  fontSize: 10,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: isPrimary
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSurface,
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
