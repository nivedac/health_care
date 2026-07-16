import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../widgets/dashboard_layout.dart';
import '../../providers/holiday_provider.dart';
import '../../models/holiday_model.dart';

class HolidayManagementScreen extends StatefulWidget {
  const HolidayManagementScreen({super.key});

  @override
  State<HolidayManagementScreen> createState() => _HolidayManagementScreenState();
}

class _HolidayManagementScreenState extends State<HolidayManagementScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HolidayProvider>().fetchHolidays();
    });
  }

  void _showHolidayModal({HolidayModel? holiday}) {
    showDialog(
      context: context,
      builder: (context) => _HolidayFormDialog(holiday: holiday),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final provider = Provider.of<HolidayProvider>(context);

    return DashboardLayout(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Holiday Management',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showHolidayModal(),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Holiday'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : provider.holidays.isEmpty
                        ? const Center(child: Text('No holidays scheduled.'))
                        : ListView.separated(
                            itemCount: provider.holidays.length,
                            separatorBuilder: (context, index) => const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final holiday = provider.holidays[index];
                              return ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                leading: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: colorScheme.errorContainer,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(Icons.event_busy, color: colorScheme.error),
                                ),
                                title: Text(
                                  holiday.name,
                                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text(DateFormat('MMMM dd, yyyy').format(holiday.date)),
                                    if (holiday.description != null && holiday.description!.isNotEmpty)
                                      Text(holiday.description!, style: theme.textTheme.bodySmall),
                                    const SizedBox(height: 4),
                                    Text(
                                      holiday.disableBooking ? 'Booking Disabled' : 'Booking Enabled',
                                      style: theme.textTheme.labelSmall?.copyWith(
                                        color: holiday.disableBooking ? Colors.red : Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () => _showHolidayModal(holiday: holiday),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        provider.deleteHoliday(holiday.id);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HolidayFormDialog extends StatefulWidget {
  final HolidayModel? holiday;

  const _HolidayFormDialog({this.holiday});

  @override
  State<_HolidayFormDialog> createState() => _HolidayFormDialogState();
}

class _HolidayFormDialogState extends State<_HolidayFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late DateTime _selectedDate;
  late bool _disableBooking;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.holiday?.name ?? '');
    _descController = TextEditingController(text: widget.holiday?.description ?? '');
    _selectedDate = widget.holiday?.date ?? DateTime.now().add(const Duration(days: 1));
    _disableBooking = widget.holiday?.disableBooking ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<HolidayProvider>();
      
      final doc = HolidayModel(
        id: widget.holiday?.id ?? '',
        date: _selectedDate,
        name: _nameController.text,
        description: _descController.text,
        disableBooking: _disableBooking,
      );

      if (widget.holiday != null) {
        provider.updateHoliday(doc);
      } else {
        provider.addHoliday(doc);
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.holiday == null ? 'Add Holiday' : 'Edit Holiday'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Holiday Name', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Description (Optional)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Date'),
                subtitle: Text(DateFormat('MMMM dd, yyyy').format(_selectedDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDate,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Disable Booking'),
                subtitle: const Text('Patients cannot book tokens on this day'),
                value: _disableBooking,
                onChanged: (v) => setState(() => _disableBooking = v),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
