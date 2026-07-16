import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/auth_provider.dart';
import '../screens/reception/walk_in_dialog.dart';

class DashboardLayout extends StatelessWidget {
  final Widget child;

  const DashboardLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Force dashboard theme for this section
    return Theme(
      data: AppTheme.dashboardTheme,
      child: Scaffold(
        body: Row(
          children: [
            _buildSidebar(context),
            Expanded(
              child: Column(
                children: [
                  _buildTopAppBar(context),
                  Expanded(
                    child: child,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentPath = GoRouterState.of(context).uri.toString();
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;
    final isAdmin = user?.role == 'admin';
    
    final roleName = isAdmin ? 'Admin Portal' : 'Reception Portal';

    return Container(
      width: 240,
      color: colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MedClinic Pro',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  roleName,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              children: [
                _buildNavItem(
                  context,
                  title: 'Dashboard',
                  icon: Icons.dashboard_outlined,
                  path: isAdmin ? '/admin' : '/reception',
                  isActive: currentPath == (isAdmin ? '/admin' : '/reception'),
                ),
                if (!isAdmin) ...[
                  _buildNavItem(
                    context,
                    title: 'Queue',
                    icon: Icons.queue_outlined,
                    path: '/reception/queue',
                    isActive: currentPath == '/reception/queue',
                  ),
                  _buildNavItem(
                    context,
                    title: 'Patients',
                    icon: Icons.group_outlined,
                    path: '/reception/search-patients',
                    isActive: currentPath == '/reception/search-patients',
                  ),
                  _buildNavItem(
                    context,
                    title: 'Walk-in',
                    icon: Icons.person_add_outlined,
                    path: '/reception/walk-in',
                    isActive: currentPath == '/reception/walk-in',
                  ),
                ],
                if (isAdmin) ...[
                  _buildNavItem(
                    context,
                    title: 'Employees',
                    icon: Icons.badge_outlined,
                    path: '/admin/employees',
                    isActive: currentPath == '/admin/employees',
                  ),
                  _buildNavItem(
                    context,
                    title: 'Doctors',
                    icon: Icons.medical_services_outlined,
                    path: '/admin/doctors',
                    isActive: currentPath == '/admin/doctors',
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                    child: Divider(),
                  ),
                  _buildNavItem(
                    context,
                    title: 'Reports',
                    icon: Icons.assessment_outlined,
                    path: '/admin/reports',
                    isActive: currentPath == '/admin/reports',
                  ),
                  _buildNavItem(
                    context,
                    title: 'Settings',
                    icon: Icons.settings_outlined,
                    path: '/admin/settings',
                    isActive: currentPath == '/admin/settings',
                  ),
                  _buildNavItem(
                    context,
                    title: 'Holidays',
                    icon: Icons.calendar_today_outlined,
                    path: '/admin/holidays',
                    isActive: currentPath == '/admin/holidays',
                  ),
                  _buildNavItem(
                    context,
                    title: 'Notifications',
                    icon: Icons.notifications_active_outlined,
                    path: '/admin/notifications',
                    isActive: currentPath == '/admin/notifications',
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: colorScheme.primaryContainer,
                  child: Icon(Icons.person, color: colorScheme.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.name ?? 'Unknown',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        isAdmin ? 'Administrator' : 'Receptionist',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.logout, size: 20),
                  onPressed: () {
                    authProvider.logout();
                    context.go('/login');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String path,
    required bool isActive,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: () {
        if (path == '/reception/walk-in') {
          showDialog(
            context: context,
            builder: (_) => Theme(
              data: AppTheme.dashboardTheme,
              child: const WalkInDialog(),
            ),
          );
        } else if (path != '#') {
          context.go(path);
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isActive ? colorScheme.secondaryContainer.withValues(alpha: 0.5) : Colors.transparent,
          border: isActive ? Border(left: BorderSide(color: colorScheme.primary, width: 4)) : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isActive ? colorScheme.primary : colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? colorScheme.primary : colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(bottom: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                'Clinic Management',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 32),
              Container(
                width: 320,
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: colorScheme.outlineVariant),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, size: 20, color: colorScheme.onSurfaceVariant),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search patients or records...',
                          border: InputBorder.none,
                          hintStyle: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.notifications_outlined, color: colorScheme.onSurfaceVariant),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.schedule_outlined, color: colorScheme.onSurfaceVariant),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.today_outlined, color: colorScheme.onSurfaceVariant),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
