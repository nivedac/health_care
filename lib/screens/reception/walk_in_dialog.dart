import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../providers/queue_provider.dart';
import '../../models/token_model.dart';
import '../../repositories/booking_repository.dart';

class WalkInDialog extends StatefulWidget {
  const WalkInDialog({super.key});

  @override
  State<WalkInDialog> createState() => _WalkInDialogState();
}

class _WalkInDialogState extends State<WalkInDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();
  final _complaintController = TextEditingController();
  String? _selectedGender;
  bool _isGenerating = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _complaintController.dispose();
    super.dispose();
  }

  void _generateToken() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isGenerating = true);

      if (!mounted) return;

      final queueProvider = Provider.of<QueueProvider>(context, listen: false);

      try {
        // Walk-in patients are booked by reception using a placeholder patientId.
        // A proper patientId would come from looking up/creating a patient record.
        // For Phase 3, we use the phone number as a stable walk-in identifier.
        final phone = _phoneController.text.trim();
        final walkInPatientId = 'walkin_$phone';

        final bookingRepo = BookingRepository();
        final result = await bookingRepo.bookAppointmentTransactionally(
          patientId: walkInPatientId,
          patientName: _nameController.text.trim(),
          patientPhone: phone,
          doctorId: 'dr_baiju_mb',
          appointmentDate: DateTime.now(),
          notes: _complaintController.text.trim().isEmpty
              ? null
              : _complaintController.text.trim(),
        );

        // Add token to live queue if open
        if (queueProvider.liveQueue != null) {
          final token = TokenModel(
            id: const Uuid().v4(),
            appointmentId: result.appointmentId,
            tokenNumber: result.tokenNumber,
            issuedAt: DateTime.now(),
            status: QueueStatus.waiting, // Walk-in → immediately waiting
            patientId: walkInPatientId,
            patientName: _nameController.text.trim(),
            patientPhone: phone,
          );
          await queueProvider.addTokenToQueue(token);
        }

        if (!mounted) return;
        setState(() => _isGenerating = false);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Token #${result.tokenNumber} generated for ${_nameController.text.trim()}'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      } on BookingClosedException catch (e) {
        setState(() => _isGenerating = false);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.orange),
        );
      } on DuplicateBookingException catch (e) {
        setState(() => _isGenerating = false);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.orange),
        );
      } catch (e) {
        setState(() => _isGenerating = false);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error generating token: $e'),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Using dashboard theme styling since this is reception
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 600,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceBright,
                border: Border(bottom: BorderSide(color: colorScheme.outlineVariant)),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: colorScheme.primaryContainer,
                        child: Icon(Icons.person_add, color: colorScheme.onPrimaryContainer),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('New Walk-in Patient', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
                          Text('Generate a queue token immediately', style: theme.textTheme.labelMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: colorScheme.onSurfaceVariant),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            
            // Form
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            label: 'Full Name',
                            controller: _nameController,
                            icon: Icons.person,
                            hint: 'e.g. John Doe',
                            validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            label: 'Phone Number',
                            controller: _phoneController,
                            icon: Icons.call,
                            hint: '+1 (555) 000-0000',
                            keyboardType: TextInputType.phone,
                            validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            label: 'Age',
                            controller: _ageController,
                            icon: Icons.calendar_today,
                            hint: 'Years',
                            keyboardType: TextInputType.number,
                            validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Gender', style: theme.textTheme.labelMedium?.copyWith(color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              DropdownButtonFormField<String>(
                                initialValue: _selectedGender,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: colorScheme.outline)),
                                ),
                                items: const [
                                  DropdownMenuItem(value: 'male', child: Text('Male')),
                                  DropdownMenuItem(value: 'female', child: Text('Female')),
                                  DropdownMenuItem(value: 'other', child: Text('Other')),
                                ],
                                onChanged: (val) => setState(() => _selectedGender = val),
                                validator: (val) => val == null ? 'Required' : null,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Chief Complaint / Reason for Visit', style: theme.textTheme.labelMedium?.copyWith(color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        TextFormField(
                          controller: _complaintController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: 'Briefly describe the symptoms or reason for the walk-in...',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: colorScheme.outline)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildChip(context, 'Fever'),
                        const SizedBox(width: 8),
                        _buildChip(context, 'Consultation'),
                        const SizedBox(width: 8),
                        _buildChip(context, 'Emergency'),
                        const SizedBox(width: 8),
                        _buildChip(context, 'Refill'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            // Footer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.cancel, color: colorScheme.onSurfaceVariant),
                    label: Text('Cancel', style: TextStyle(color: colorScheme.onSurfaceVariant)),
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text('Save Draft', style: TextStyle(color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: _isGenerating ? null : _generateToken,
                        icon: _isGenerating ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.confirmation_number),
                        label: Text(_isGenerating ? 'Generating...' : 'Generate Token', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    String? hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.labelMedium?.copyWith(color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: Icon(icon, color: colorScheme.outlineVariant),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: colorScheme.outline)),
          ),
        ),
      ],
    );
  }

  Widget _buildChip(BuildContext context, String label) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () {
        final currentText = _complaintController.text;
        _complaintController.text = currentText.isEmpty ? label : '$currentText, $label';
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(label, style: Theme.of(context).textTheme.labelMedium),
      ),
    );
  }
}
