import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutam_fit/constants/app_colors.dart';
import 'package:tutam_fit/providers/auth_provider.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: const Text(
                'Account Center',
                style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                context.push('/signup');
              },
              icon: Icon(Icons.app_registration, color: AppColors.white),
            ),
          ],
        ),
        backgroundColor: AppColors.deepNavy,
      ),
      body: ListView(
        children: [
          _ProfileHeader(user: user),
          const SizedBox(height: 8),
          _sectionTitle('My Activity'),
          _accountItem(
            icon: Icons.favorite,
            title: 'Wishlist',
            onTap: user != null ? () => context.push('/wishlist') : null,
          ),
          _accountItem(
            icon: Icons.shopping_bag,
            title: 'My Orders',
            onTap: user != null ? () => context.push('/orders') : null,
          ),
          _accountItem(
            icon: Icons.star,
            title: 'Ratings',
            onTap: () => context.push('/ratings'),
          ),
          _accountItem(
            icon: Icons.rate_review,
            title: 'Reviews',
            onTap: () => context.push('/reviews'),
          ),
          _accountItem(
            icon: Icons.history,
            title: 'Recently Viewed',
            onTap: () => context.push('/recently-viewed'),
          ),

          _sectionTitle('Payments & Addresses'),
          _accountItem(
            icon: Icons.account_balance_wallet,
            title: 'Balance',
            onTap: user != null ? () => context.push('/balance') : null,
          ),
          _accountItem(
            icon: Icons.location_on,
            title: 'Address Book',
            onTap: user != null ? () => context.push('/address-book') : null,
          ),

          _sectionTitle('Preferences'),
          _accountItem(
            icon: Icons.notifications,
            title: 'Notification Preferences',
            onTap: () => context.push('/notification-preferences'),
          ),
          _accountItem(
            icon: Icons.settings,
            title: 'Settings',
            onTap: () => context.push('/settings'),
          ),

          _sectionTitle('Support'),
          _accountItem(
            icon: Icons.help_outline,
            title: 'FAQ',
            onTap: () => context.push('/faq'),
          ),
          _accountItem(
            icon: Icons.support_agent,
            title: 'Customer Service',
            onTap: () => context.push('/customer-service'),
          ),

          if (user != null) ...[
            const SizedBox(height: 16),
            _accountItem(
              icon: Icons.logout,
              title: 'Logout',
              onTap: () async {
                await ref.read(authStateProvider.notifier).logout();
                context.go('/login');
              },
            ),
          ],
        ],
      ),
    );
  }
}

Widget _sectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
    child: Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: AppColors.darkGray,
      ),
    ),
  );
}

Widget _accountItem({
  required IconData icon,
  required String title,
  required VoidCallback? onTap,
}) {
  return ListTile(
    leading: Icon(icon, color: AppColors.primaryRed),
    title: Text(title),
    trailing: const Icon(Icons.chevron_right),
    onTap: onTap,
    enabled: onTap != null,
  );
}

class _ProfileHeader extends ConsumerWidget {
  final dynamic user;

  const _ProfileHeader({this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      child: InkWell(
        onTap: () {
          if (user == null) {
            context.push('/login');
          } else {
            context.push('/profile'); // Edit profile
          }
        },
        child: Container(
          color: AppColors.darkGray,
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.limeGreen,
                child: Icon(Icons.person, size: 30, color: AppColors.darkGray),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.name ?? 'Guest User',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user == null ? 'Tap to login' : user.email,
                    style: const TextStyle(color: AppColors.white),
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
