import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/dashboard_layout.dart';
import '../../providers/notification_provider.dart';
import '../../repositories/notification_repository.dart';
import '../../models/notification_model.dart';
import '../../core/error_handler.dart';

class NotificationCenterScreen extends StatefulWidget {
  const NotificationCenterScreen({super.key});

  @override
  State<NotificationCenterScreen> createState() => _NotificationCenterScreenState();
}

class _NotificationCenterScreenState extends State<NotificationCenterScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _messageController;
  
  String _targetGroup = 'All Patients';
  final List<String> _groups = ['All Patients', 'Today\'s Patients', 'Specific Patient'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _sendNotification() async {
    if (_formKey.currentState!.validate()) {
      
      // Send real notification
      try {
        final notifRepo = NotificationRepository();
        await notifRepo.createNotification(
          NotificationModel(
            id: '',
            userId: 'global', // Broadcast to all users
            title: _titleController.text,
            message: _messageController.text,
            timestamp: DateTime.now(),
            isRead: false,
          ),
        );
      } catch (e, stack) {
        ErrorHandler.handleError(e, stackTrace: stack);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Notification sent to $_targetGroup!')),
      );

      _titleController.clear();
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final provider = Provider.of<NotificationProvider>(context);

    return DashboardLayout(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Notification Center',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Send New Notification', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 24),
                          DropdownButtonFormField<String>(
                            initialValue: _targetGroup,
                            decoration: const InputDecoration(labelText: 'Target Audience', border: OutlineInputBorder()),
                            items: _groups.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                            onChanged: (v) => setState(() => _targetGroup = v!),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _titleController,
                            decoration: const InputDecoration(labelText: 'Notification Title', border: OutlineInputBorder()),
                            validator: (v) => v!.isEmpty ? 'Required' : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _messageController,
                            maxLines: 4,
                            decoration: const InputDecoration(labelText: 'Message Body', border: OutlineInputBorder(), alignLabelWithHint: true),
                            validator: (v) => v!.isEmpty ? 'Required' : null,
                          ),
                          const SizedBox(height: 24),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                              onPressed: _sendNotification,
                              icon: const Icon(Icons.send),
                              label: const Text('Send Notification'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                backgroundColor: colorScheme.primary,
                                foregroundColor: colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 32),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Recent Broadcasts', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        provider.notifications.isEmpty
                            ? const Center(child: Text('No recent notifications.'))
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: provider.notifications.length,
                                itemBuilder: (context, index) {
                                  final notif = provider.notifications[index];
                                  return ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: CircleAvatar(
                                      backgroundColor: colorScheme.primaryContainer,
                                      child: Icon(Icons.notifications, color: colorScheme.primary),
                                    ),
                                    title: Text(notif.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                                    subtitle: Text(notif.message, maxLines: 2, overflow: TextOverflow.ellipsis),
                                  );
                                },
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
}
