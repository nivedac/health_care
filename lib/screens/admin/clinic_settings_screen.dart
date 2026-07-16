import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/dashboard_layout.dart';
import '../../providers/settings_provider.dart';
import '../../models/clinic_settings_model.dart';

class ClinicSettingsScreen extends StatefulWidget {
  const ClinicSettingsScreen({super.key});

  @override
  State<ClinicSettingsScreen> createState() => _ClinicSettingsScreenState();
}

class _ClinicSettingsScreenState extends State<ClinicSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _feeController;
  late TextEditingController _openTimeController;
  late TextEditingController _closeTimeController;
  late TextEditingController _avgConsultController;
  late TextEditingController _maxPatientsController;
  late TextEditingController _tokenPrefixController;
  
  bool _queueEnabled = true;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with empty strings to avoid late initialization error
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _phoneController = TextEditingController();
    _feeController = TextEditingController();
    _openTimeController = TextEditingController();
    _closeTimeController = TextEditingController();
    _avgConsultController = TextEditingController();
    _maxPatientsController = TextEditingController();
    _tokenPrefixController = TextEditingController();
    
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<SettingsProvider>();
      await provider.fetchSettings();
      _initializeControllers(provider.settings);
    });
  }

  void _initializeControllers(ClinicSettingsModel? settings) {
    if (settings != null) {
      setState(() {
        _nameController.text = settings.clinicName;
        _addressController.text = settings.clinicAddress;
        _phoneController.text = settings.phoneNumber;
        _feeController.text = settings.consultationFee.toString();
        _openTimeController.text = settings.openingTime;
        _closeTimeController.text = settings.closingTime;
        _avgConsultController.text = settings.averageConsultationTimeMinutes.toString();
        _maxPatientsController.text = settings.maximumDailyPatients.toString();
        _tokenPrefixController.text = settings.tokenPrefix ?? '';
        _queueEnabled = settings.isQueueEnabled;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _feeController.dispose();
    _openTimeController.dispose();
    _closeTimeController.dispose();
    _avgConsultController.dispose();
    _maxPatientsController.dispose();
    _tokenPrefixController.dispose();
    super.dispose();
  }

  Future<void> _saveSettings() async {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<SettingsProvider>();
      
      final updatedSettings = ClinicSettingsModel(
        id: provider.settings?.id ?? 's1',
        clinicName: _nameController.text,
        clinicAddress: _addressController.text,
        phoneNumber: _phoneController.text,
        consultationFee: double.tryParse(_feeController.text) ?? 500.0,
        openingTime: _openTimeController.text,
        closingTime: _closeTimeController.text,
        averageConsultationTimeMinutes: int.tryParse(_avgConsultController.text) ?? 15,
        maximumDailyPatients: int.tryParse(_maxPatientsController.text) ?? 50,
        isQueueEnabled: _queueEnabled,
        tokenPrefix: _tokenPrefixController.text.isNotEmpty ? _tokenPrefixController.text : null,
      );

      await provider.updateSettings(updatedSettings);
      // ignore: use_build_context_synchronously
      if (!mounted) return;
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Settings saved successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final provider = Provider.of<SettingsProvider>(context);

    return DashboardLayout(
      child: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Clinic Settings',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _saveSettings,
                        icon: const Icon(Icons.save),
                        label: const Text('Save Settings'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Container(
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
                          Text('General Information', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(child: _buildTextField('Clinic Name', _nameController)),
                              const SizedBox(width: 24),
                              Expanded(child: _buildTextField('Phone Number', _phoneController)),
                            ],
                          ),
                          const SizedBox(height: 24),
                          _buildTextField('Clinic Address', _addressController, maxLines: 2),
                          const SizedBox(height: 48),
                          
                          Text('Operational Details', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(child: _buildTextField('Opening Time', _openTimeController)),
                              const SizedBox(width: 24),
                              Expanded(child: _buildTextField('Closing Time', _closeTimeController)),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(child: _buildTextField('Average Consultation Time (mins)', _avgConsultController, isNumber: true)),
                              const SizedBox(width: 24),
                              Expanded(child: _buildTextField('Consultation Fee (₹)', _feeController, isNumber: true)),
                            ],
                          ),
                          const SizedBox(height: 48),

                          Text('Queue Configuration', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(child: _buildTextField('Maximum Daily Patients', _maxPatientsController, isNumber: true)),
                              const SizedBox(width: 24),
                              Expanded(child: _buildTextField('Token Prefix (Optional)', _tokenPrefixController)),
                            ],
                          ),
                          const SizedBox(height: 24),
                          SwitchListTile(
                            title: const Text('Enable Online Queue Booking'),
                            subtitle: const Text('Allow patients to book tokens through the mobile app'),
                            value: _queueEnabled,
                            onChanged: (bool value) {
                              setState(() {
                                _queueEnabled = value;
                              });
                            },
                            contentPadding: EdgeInsets.zero,
                            activeThumbColor: colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1, bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        alignLabelWithHint: maxLines > 1,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          if (label.contains('Optional')) return null;
          return 'This field is required';
        }
        return null;
      },
    );
  }
}
