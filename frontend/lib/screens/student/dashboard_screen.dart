import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../utils/colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/referral_provider.dart';

class StudentDashboardScreen extends ConsumerWidget {
  const StudentDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).value;
    final referrals = ref.watch(referralsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Welcome!',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (user != null)
                            Text(
                              '${user.firstName} ${user.lastName}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.gray600,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Quick action buttons
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                _QuickActionButton(
                  icon: Icons.add_circle_outline,
                  label: 'Create Referral',
                  onTap: () => context.go('/student/create-referral'),
                ),
                _QuickActionButton(
                  icon: Icons.list_alt,
                  label: 'My Referrals',
                  onTap: () => context.go('/student/my-referrals'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Referrals summary
            const Text(
              'Recent Referrals',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            referrals.when(
              data: (data) => data.isEmpty
                  ? Container(
                      padding: const EdgeInsets.all(24),
                      child: const Text('No referrals yet'),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: data.take(5).length,
                      itemBuilder: (context, index) {
                        final referral = data[index];
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: ListTile(
                              title: Text(referral.referralId),
                              subtitle: Text(referral.status),
                              trailing: _PriorityBadge(priority: referral.priority),
                              onTap: () => context.go(
                                '/student/referral/${referral.referralId}',
                              ),
                            ),
                          ),
                        );
                      },
                    ),
              loading: () => const CircularProgressIndicator(),
              error: (err, stack) => Text('Error: $err'),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: AppColors.primary),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

class _PriorityBadge extends StatelessWidget {
  final String priority;

  const _PriorityBadge({required this.priority});

  Color _getPriorityColor() {
    switch (priority) {
      case 'EMERGENCY':
        return AppColors.emergency;
      case 'HIGH':
        return AppColors.high;
      default:
        return AppColors.routine;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getPriorityColor(),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        priority,
        style: const TextStyle(
          color: AppColors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
