import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/navigation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onBottomNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // In a real app, you would swap out the body or navigate.
    // We only have the home flow defined for now.
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final authProvider = Provider.of<AuthProvider>(context);
    final userName = authProvider.currentUser?.name ?? 'User';

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: AppBar(
          backgroundColor: colorScheme.surface.withValues(alpha: 0.8),
          elevation: 0,
          scrolledUnderElevation: 0,
          leadingWidth: 0,
          leading: const SizedBox.shrink(),
          title: Row(
            children: [
              CircleAvatar(
                backgroundImage: const NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuB-9BCHX5xqlqNop2SmTWkDvRPSkLavbf5HMxR8Abz1uIUpLsfaMr4xKnWF3F99jdcw_wG2aqU3EIcx-ewF35Jkou2Jya6htYE5NlRHWe_c4ejXs5DvU5A4yeyk66evusYaJEgUH-DLxufwTWL-8nMVWvUvqOKcQkU298bOwRsPhImfQi00rRJbKmbkojYd-7lbJ-3vzVOA2NsXohKrQjEtpitYB02uba0S4AO5_XRHck8aimoeeB2buT47-9bAjhp6BTGjfxjuZg'),
                radius: 20,
                backgroundColor: colorScheme.surfaceContainerHighest,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Good Evening, $userName',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.notifications, color: colorScheme.onSurfaceVariant),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Doctor Card
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
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuAPcyBY-0K0RK34hZV8igjnb038ZckUJH3EZf27kRVtO9aSE9F-_0A_B42Byi9DkRHvD6urhkQtdc1h4Es2nojgLujRlPRgPxbO3ILKvyuSQDhPuSiB4m5PPIAIk1groK2o3LH6EIPOOc2nLLhfYk-1WtGZOtHBw8NmEJueLqCqWg9GRvMueHBIQBgvkxHY8jX1-trs4S4ccFX2TZmhhdqVhR4nlC_InfSlSan2e-cYUdSE9vX37nAYfHcw_9wA0_qtEUNfCylw8Q',
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Dr. Baiju', style: theme.textTheme.titleMedium),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.medical_services, size: 16, color: colorScheme.secondary),
                            const SizedBox(width: 4),
                            Text('General Physician', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.secondary)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: colorScheme.tertiaryContainer.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            'Available Today 4:30 PM - 7:30 PM',
                            style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.tertiary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Queue Dashboard
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
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
                      children: [
                        Text('CURRENT TOKEN', style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.secondary)),
                        const SizedBox(height: 8),
                        Text('18', style: theme.textTheme.displayMedium?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
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
                      children: [
                        Text('WAITING', style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.secondary)),
                        const SizedBox(height: 8),
                        Text('6', style: theme.textTheme.headlineSmall),
                        Icon(Icons.group, color: colorScheme.secondary.withValues(alpha: 0.5), size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
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
                      children: [
                        Text('EST. WAIT', style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.secondary)),
                        const SizedBox(height: 8),
                        Text('38m', style: theme.textTheme.headlineSmall),
                        Icon(Icons.schedule, color: colorScheme.secondary.withValues(alpha: 0.5), size: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Book Token Button
            ElevatedButton.icon(
              onPressed: () => context.push('/book-token'),
              icon: const Icon(Icons.add_circle),
              label: const Text('Book Token'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                side: BorderSide(color: colorScheme.primary, width: 2),
                elevation: 4,
                shadowColor: colorScheme.primary.withValues(alpha: 0.3),
              ),
            ),
            const SizedBox(height: 32),

            // Quick Actions Bento Grid
            Text('Quick Actions', style: theme.textTheme.titleMedium),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                _buildActionCard(
                  context: context,
                  title: 'Appointments',
                  icon: Icons.calendar_today,
                  color: colorScheme.primary,
                  onTap: () {},
                ),
                _buildActionCard(
                  context: context,
                  title: 'History',
                  icon: Icons.history,
                  color: colorScheme.secondary,
                  onTap: () {},
                ),
                _buildActionCard(
                  context: context,
                  title: 'Directions',
                  icon: Icons.directions,
                  color: colorScheme.tertiary,
                  onTap: () {},
                ),
                _buildActionCard(
                  context: context,
                  title: 'Emergency',
                  icon: Icons.emergency,
                  color: colorScheme.error,
                  isError: true,
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 32), // padding for bottom nav
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemSelected: _onBottomNavTapped,
      ),
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool isError = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isError ? colorScheme.errorContainer.withValues(alpha: 0.2) : colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isError ? colorScheme.error.withValues(alpha: 0.1) : colorScheme.surfaceContainerHighest),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 40, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isError ? colorScheme.errorContainer : color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color),
            ),
            const Spacer(),
            Text(
              title,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color: isError ? colorScheme.error : colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
