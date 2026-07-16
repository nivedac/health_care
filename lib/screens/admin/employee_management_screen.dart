import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/dashboard_layout.dart';
import '../../providers/employee_provider.dart';
import '../../models/employee_model.dart';

class EmployeeManagementScreen extends StatefulWidget {
  const EmployeeManagementScreen({super.key});

  @override
  State<EmployeeManagementScreen> createState() => _EmployeeManagementScreenState();
}

class _EmployeeManagementScreenState extends State<EmployeeManagementScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EmployeeProvider>().fetchEmployees();
    });
  }

  void _showEmployeeModal({EmployeeModel? employee}) {
    showDialog(
      context: context,
      builder: (context) => _EmployeeFormDialog(employee: employee),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final employeeProvider = Provider.of<EmployeeProvider>(context);

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
                  'Employee Management',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showEmployeeModal(),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Employee'),
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
                child: employeeProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('Name')),
                            DataColumn(label: Text('Role')),
                            DataColumn(label: Text('Department')),
                            DataColumn(label: Text('Phone')),
                            DataColumn(label: Text('Status')),
                            DataColumn(label: Text('Actions')),
                          ],
                          rows: employeeProvider.employees.map((employee) {
                            return DataRow(
                              cells: [
                                DataCell(Text(employee.name)),
                                DataCell(Text(employee.position)),
                                DataCell(Text(employee.department)),
                                DataCell(Text(employee.phone ?? '-')),
                                DataCell(
                                  Chip(
                                    label: Text(employee.isActive ? 'Active' : 'Inactive'),
                                    backgroundColor: employee.isActive ? Colors.green.withValues(alpha: 0.1) : Colors.red.withValues(alpha: 0.1),
                                    labelStyle: TextStyle(
                                      color: employee.isActive ? Colors.green : Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    side: BorderSide.none,
                                  ),
                                ),
                                DataCell(
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.blue),
                                        onPressed: () => _showEmployeeModal(employee: employee),
                                        tooltip: 'Edit',
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          employee.isActive ? Icons.block : Icons.check_circle,
                                          color: employee.isActive ? Colors.orange : Colors.green,
                                        ),
                                        onPressed: () {
                                          employeeProvider.activateEmployee(employee.id, !employee.isActive);
                                        },
                                        tooltip: employee.isActive ? 'Deactivate' : 'Activate',
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () {
                                          employeeProvider.deleteEmployee(employee.id);
                                        },
                                        tooltip: 'Delete',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmployeeFormDialog extends StatefulWidget {
  final EmployeeModel? employee;

  const _EmployeeFormDialog({this.employee});

  @override
  State<_EmployeeFormDialog> createState() => _EmployeeFormDialogState();
}

class _EmployeeFormDialogState extends State<_EmployeeFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late String _role;
  late String _department;

  final List<String> _roles = ['Receptionist', 'Administrator', 'Nurse', 'Assistant'];
  final List<String> _departments = ['Front Desk', 'Management', 'Nursing', 'Operations'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.employee?.name ?? '');
    _phoneController = TextEditingController(text: widget.employee?.phone ?? '');
    _emailController = TextEditingController(text: widget.employee?.email ?? '');
    _role = widget.employee?.position ?? _roles.first;
    _department = widget.employee?.department ?? _departments.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<EmployeeProvider>();
      
      if (widget.employee != null) {
        // Edit
        provider.updateEmployee(
          widget.employee!.copyWith(
            name: _nameController.text,
            phone: _phoneController.text,
            email: _emailController.text,
            position: _role,
            department: _department,
          ),
        );
      } else {
        // Add
        provider.addEmployee(
          EmployeeModel(
            id: '', // Will be replaced by repo
            userId: 'new_user',
            name: _nameController.text,
            position: _role,
            department: _department,
            phone: _phoneController.text,
            email: _emailController.text,
          ),
        );
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.employee == null ? 'Add Employee' : 'Edit Employee'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Full Name', border: OutlineInputBorder()),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone', border: OutlineInputBorder()),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                  validator: (v) => v!.isEmpty || !v.contains('@') ? 'Enter a valid email' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _role,
                  decoration: const InputDecoration(labelText: 'Role', border: OutlineInputBorder()),
                  items: _roles.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                  onChanged: (v) => setState(() => _role = v!),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _department,
                  decoration: const InputDecoration(labelText: 'Department', border: OutlineInputBorder()),
                  items: _departments.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                  onChanged: (v) => setState(() => _department = v!),
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
