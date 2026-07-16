import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/dashboard_layout.dart';
import '../../providers/doctor_provider.dart';
import '../../models/doctor_model.dart';

class DoctorManagementScreen extends StatefulWidget {
  const DoctorManagementScreen({super.key});

  @override
  State<DoctorManagementScreen> createState() => _DoctorManagementScreenState();
}

class _DoctorManagementScreenState extends State<DoctorManagementScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DoctorProvider>().fetchDoctors();
    });
  }

  void _showDoctorModal({DoctorModel? doctor}) {
    showDialog(
      context: context,
      builder: (context) => _DoctorFormDialog(doctor: doctor),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final doctorProvider = Provider.of<DoctorProvider>(context);

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
                  'Doctor Management',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showDoctorModal(),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Doctor'),
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
              child: doctorProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 24,
                        mainAxisSpacing: 24,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: doctorProvider.doctors.length,
                      itemBuilder: (context, index) {
                        final doctor = doctorProvider.doctors[index];
                        return _buildDoctorCard(context, doctor);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorCard(BuildContext context, DoctorModel doctor) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: colorScheme.primaryContainer,
                    child: Text(
                      doctor.name.substring(0, 2).toUpperCase(),
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    doctor.name,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    doctor.specialization,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  _buildDetailRow(context, Icons.school, doctor.qualification),
                  _buildDetailRow(context, Icons.work, doctor.experience),
                  _buildDetailRow(context, Icons.payments, '₹${doctor.consultationFee.toStringAsFixed(0)}'),
                  _buildDetailRow(context, Icons.schedule, '${doctor.startTime} - ${doctor.endTime}'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    alignment: WrapAlignment.center,
                    children: doctor.availableDays.map((day) => Chip(
                      label: Text(day.substring(0, 3)),
                      labelStyle: const TextStyle(fontSize: 10),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    )).toList(),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  onPressed: () => _showDoctorModal(doctor: doctor),
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Edit'),
                ),
                TextButton.icon(
                  onPressed: () {
                    if (doctor.isAvailable) {
                      context.read<DoctorProvider>().deactivateDoctor(doctor.id);
                    }
                  },
                  icon: Icon(
                    doctor.isAvailable ? Icons.block : Icons.check_circle,
                    size: 18,
                    color: doctor.isAvailable ? Colors.orange : Colors.green,
                  ),
                  label: Text(
                    doctor.isAvailable ? 'Deactivate' : 'Activate',
                    style: TextStyle(color: doctor.isAvailable ? Colors.orange : Colors.green),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    context.read<DoctorProvider>().deleteDoctor(doctor.id);
                  },
                  icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                  label: const Text('Delete', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String text) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _DoctorFormDialog extends StatefulWidget {
  final DoctorModel? doctor;

  const _DoctorFormDialog({this.doctor});

  @override
  State<_DoctorFormDialog> createState() => _DoctorFormDialogState();
}

class _DoctorFormDialogState extends State<_DoctorFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _specializationController;
  late TextEditingController _qualificationController;
  late TextEditingController _experienceController;
  late TextEditingController _feeController;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;

  final List<String> _allDays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  late List<String> _selectedDays;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.doctor?.name ?? '');
    _specializationController = TextEditingController(text: widget.doctor?.specialization ?? '');
    _qualificationController = TextEditingController(text: widget.doctor?.qualification ?? '');
    _experienceController = TextEditingController(text: widget.doctor?.experience ?? '');
    _feeController = TextEditingController(text: widget.doctor?.consultationFee.toString() ?? '500');
    _startTimeController = TextEditingController(text: widget.doctor?.startTime ?? '09:00 AM');
    _endTimeController = TextEditingController(text: widget.doctor?.endTime ?? '05:00 PM');
    _selectedDays = widget.doctor != null ? List.from(widget.doctor!.availableDays) : ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _specializationController.dispose();
    _qualificationController.dispose();
    _experienceController.dispose();
    _feeController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<DoctorProvider>();
      
      final doc = DoctorModel(
        id: widget.doctor?.id ?? '',
        userId: widget.doctor?.userId ?? 'doc_user',
        name: _nameController.text,
        specialization: _specializationController.text,
        qualification: _qualificationController.text,
        experience: _experienceController.text,
        consultationFee: double.tryParse(_feeController.text) ?? 500.0,
        availableDays: _selectedDays,
        startTime: _startTimeController.text,
        endTime: _endTimeController.text,
        isAvailable: widget.doctor?.isAvailable ?? true,
      );

      if (widget.doctor != null) {
        provider.updateDoctor(doc);
      } else {
        provider.addDoctor(doc);
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.doctor == null ? 'Add Doctor' : 'Edit Doctor'),
      content: SizedBox(
        width: 500,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Full Name', border: OutlineInputBorder()),
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _specializationController,
                        decoration: const InputDecoration(labelText: 'Specialization', border: OutlineInputBorder()),
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _qualificationController,
                        decoration: const InputDecoration(labelText: 'Qualification', border: OutlineInputBorder()),
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _experienceController,
                        decoration: const InputDecoration(labelText: 'Experience', border: OutlineInputBorder()),
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _feeController,
                        decoration: const InputDecoration(labelText: 'Consultation Fee', border: OutlineInputBorder()),
                        keyboardType: TextInputType.number,
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _startTimeController,
                        decoration: const InputDecoration(labelText: 'Start Time', border: OutlineInputBorder()),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _endTimeController,
                        decoration: const InputDecoration(labelText: 'End Time', border: OutlineInputBorder()),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Available Days', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _allDays.map((day) {
                    final isSelected = _selectedDays.contains(day);
                    return FilterChip(
                      label: Text(day),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedDays.add(day);
                          } else {
                            _selectedDays.remove(day);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
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
