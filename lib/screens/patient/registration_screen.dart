import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();
  final _addressController = TextEditingController();
  
  String? _selectedGender;
  String? _selectedBloodGroup;
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Populate phone number from AuthProvider if available
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.currentUser != null) {
      _phoneController.text = authProvider.currentUser!.phoneNumber ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _onSave() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    // Mock save
    await Future.delayed(const Duration(seconds: 1));
    
    if (mounted) {
      setState(() => _isLoading = false);
      context.go('/patient');
    }
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required IconData prefixIcon,
    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Row(
          children: [
            Icon(prefixIcon, color: colorScheme.secondary),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue: value,
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: theme.textTheme.labelSmall?.copyWith(color: colorScheme.secondary),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                icon: Icon(Icons.arrow_drop_down, color: colorScheme.secondary),
                style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
                items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: onChanged,
                validator: validator,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomTextField({
    required String label,
    required TextEditingController controller,
    required IconData prefixIcon,
    String? hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    bool readOnly = false,
    String? Function(String?)? validator,
    String? suffixText,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        crossAxisAlignment: maxLines > 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: maxLines > 1 ? 16.0 : 0),
            child: Icon(prefixIcon, color: colorScheme.secondary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.secondary),
                    ),
                    if (suffixText != null)
                      Text(
                        suffixText,
                        style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.outline),
                      ),
                  ],
                ),
                TextFormField(
                  controller: controller,
                  readOnly: readOnly,
                  keyboardType: keyboardType,
                  maxLines: maxLines,
                  validator: validator,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: readOnly ? colorScheme.onSurfaceVariant : colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(color: colorScheme.outlineVariant),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.only(top: 4, bottom: 4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLow,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Container(
              margin: MediaQuery.of(context).size.width > 600 
                  ? const EdgeInsets.symmetric(vertical: 40)
                  : EdgeInsets.zero,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width > 600 ? 24 : 0),
                boxShadow: MediaQuery.of(context).size.width > 600 
                    ? [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 40, offset: const Offset(0, 20))]
                    : null,
              ),
              child: Column(
                children: [
                  // Header Image Area
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width > 600 ? 24 : 0),
                      image: const DecorationImage(
                        image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuCcs5g5M8NXkqvrp3rcuoxRAXhguiS5bLoDeo88ERxyrkldPaSxr_L6xNbZzxHZ5dFCndQdk3H6xK0irR7wpoMpr7B3VmY7Zik2qrK5O7rL_dyXqo0gkFfzp37LG_WWGSrxbcBGYu98rvdJXJL8-Q6--mMt1oER72hlis8lF1H9Jwb63JN-dhVM6KyzWHHfXocUw2RZaxZLlhoMJvz6k2HK8SvjF7ossl_lPY6AC14MEAQt-TMGOen8sSX4EGDLd4QqNdo4xv4mxg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  
                  // Content Area
                  Expanded(
                    child: Transform.translate(
                      offset: const Offset(0, -24),
                      child: Container(
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerLowest,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Patient Registration',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Please provide your details to complete setup.',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.secondary,
                                ),
                              ),
                              const SizedBox(height: 24),
                              
                              Expanded(
                                child: ListView(
                                  children: [
                                    _buildCustomTextField(
                                      label: 'Full Name',
                                      hint: 'Jane Doe',
                                      controller: _nameController,
                                      prefixIcon: Icons.person,
                                      validator: (v) => v!.isEmpty ? 'Required' : null,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildCustomTextField(
                                      label: 'Phone Number',
                                      controller: _phoneController,
                                      prefixIcon: Icons.phone,
                                      readOnly: _phoneController.text.isNotEmpty,
                                      validator: (v) => v!.isEmpty ? 'Required' : null,
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildCustomTextField(
                                            label: 'Age',
                                            hint: 'e.g. 34',
                                            controller: _ageController,
                                            prefixIcon: Icons.cake,
                                            keyboardType: TextInputType.number,
                                            validator: (v) => v!.isEmpty ? 'Required' : null,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: _buildDropdown(
                                            label: 'Gender',
                                            value: _selectedGender,
                                            prefixIcon: Icons.wc,
                                            items: const ['Female', 'Male', 'Other', 'Prefer not to say'],
                                            onChanged: (v) => setState(() => _selectedGender = v),
                                            validator: (v) => v == null ? 'Required' : null,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    _buildDropdown(
                                      label: 'Blood Group',
                                      value: _selectedBloodGroup,
                                      prefixIcon: Icons.bloodtype,
                                      items: const ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'],
                                      onChanged: (v) => setState(() => _selectedBloodGroup = v),
                                    ),
                                    const SizedBox(height: 16),
                                    _buildCustomTextField(
                                      label: 'Address',
                                      hint: 'Enter your full address',
                                      controller: _addressController,
                                      prefixIcon: Icons.home,
                                      maxLines: 3,
                                      suffixText: 'Optional',
                                    ),
                                  ],
                                ),
                              ),
                              
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colorScheme.primary,
                                  foregroundColor: colorScheme.onPrimary,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                  elevation: 4,
                                  shadowColor: colorScheme.primary.withValues(alpha: 0.25),
                                ),
                                onPressed: _isLoading ? null : _onSave,
                                icon: _isLoading 
                                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                    : const Icon(Icons.check_circle),
                                label: Text(
                                  'Save Details',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: colorScheme.onPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
