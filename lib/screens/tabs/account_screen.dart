import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutam_fit/providers/auth_provider.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Account Center',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: theme.primaryColor,
      ),
      body: ListView(
        children: [
          _ProfileHeader(user: user),
          const SizedBox(height: 8),
          // After the Support section, before Logout
          if (user != null && user.role == 'admin') ...[
            _sectionTitle('Admin', theme),
            _accountItem(
              icon: Icons.admin_panel_settings,
              title: 'Admin',
              onTap: () => context.push('/admin'),
              theme: theme,
            ),
          ],
          _sectionTitle('My Activity', theme),
          _accountItem(
            icon: Icons.favorite,
            title: 'Wishlist',
            onTap: user != null ? () => context.push('/wishlist') : null,
            theme: theme,
          ),
          _accountItem(
            icon: Icons.shopping_bag,
            title: 'My Orders',
            onTap: user != null ? () => context.push('/user-orders') : null,
            theme: theme,
          ),
          _accountItem(
            icon: Icons.star,
            title: 'Ratings',
            onTap: () => context.push('/ratings'),
            theme: theme,
          ),
          _accountItem(
            icon: Icons.rate_review,
            title: 'Reviews',
            onTap: () => context.push('/user-reviews'),
            theme: theme,
          ),
          _sectionTitle('Payments & Addresses', theme),
          _accountItem(
            icon: Icons.account_balance_wallet,
            title: 'Balance',
            onTap: user != null ? () => context.push('/balance') : null,
            theme: theme,
          ),
          _accountItem(
            icon: Icons.location_on,
            title: 'Address Book',
            onTap: user != null ? () => context.push('/address-book') : null,
            theme: theme,
          ),
          _sectionTitle('Preferences', theme),
          _accountItem(
            icon: Icons.notifications,
            title: 'Notification Preferences',
            onTap: () => context.push('/notification-preferences'),
            theme: theme,
          ),
          _accountItem(
            icon: Icons.settings,
            title: 'Settings',
            onTap: () => context.push('/settings'),
            theme: theme,
          ),
          _sectionTitle('Support', theme),
          _accountItem(
            icon: Icons.help_outline,
            title: 'FAQ',
            onTap: () => context.push('/faq'),
            theme: theme,
          ),
          _accountItem(
            icon: Icons.support_agent,
            title: 'Customer Service',
            onTap: () => context.push('/customer-service'),
            theme: theme,
          ),
          if (user != null) ...[
            const SizedBox(height: 16),
            _accountItem(
              icon: Icons.logout,
              title: 'Logout',
              onTap: () async {
                await ref.read(authStateProvider.notifier).logout();
                context.go('/login');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Logged out successfully'),
                    backgroundColor: theme.colorScheme.secondary,
                  ),
                );
              },
              theme: theme,
            ),
          ],
        ],
      ),
    );
  }
}

Widget _sectionTitle(String title, ThemeData theme) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
    child: Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.textTheme.bodyMedium?.color,
      ),
    ),
  );
}

Widget _accountItem({
  required IconData icon,
  required String title,
  required VoidCallback? onTap,
  required ThemeData theme,
}) {
  return ListTile(
    leading: Icon(icon, color: theme.colorScheme.secondary),
    title: Text(title, style: theme.textTheme.bodyMedium),
    trailing: Icon(Icons.chevron_right, color: theme.unselectedWidgetColor),
    onTap: onTap,
    enabled: onTap != null,
  );
}

class _ProfileHeader extends ConsumerWidget {
  final dynamic user;

  const _ProfileHeader({this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Material(
      color: theme.cardColor,
      child: InkWell(
        onTap: () {
          if (user == null) {
            context.push('/login');
          } else {
            context.push('/profile');
          }
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: theme.colorScheme.secondary,
                child: Icon(Icons.person, size: 30, color: theme.cardColor),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.name ?? 'Guest User',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user == null ? 'Tap to login' : user.email,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
