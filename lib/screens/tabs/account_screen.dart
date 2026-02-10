import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tutam_fit/constants/app_colors.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: const Text(
            'Account Center',
            style: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: AppColors.deepNavy,
      ),
      body: ListView(
        children: [
          _ProfileHeader(),
          const SizedBox(height: 8),
          _sectionTitle('My Activity'),
          _accountItem(
            icon: Icons.favorite,
            title: 'Wishlist',
            onTap: () {
              context.push('/wishlist');
            },
          ),
          _accountItem(
            icon: Icons.shopping_bag,
            title: 'My Orders',
            onTap: () {
              context.push('/orders');
            },
          ),
          _accountItem(
            icon: Icons.star,
            title: 'Ratings',
            onTap: () {
              context.push('/ratings');
            },
          ),
          _accountItem(
            icon: Icons.rate_review,
            title: 'Reviews',
            onTap: () {
              context.push('/reviews');
            },
          ),
          _accountItem(
            icon: Icons.history,
            title: 'Recently Viewed',
            onTap: () {
              context.push('/recently-viewed');
            },
          ),

          _sectionTitle('Payments & Addresses'),
          _accountItem(
            icon: Icons.account_balance_wallet,
            title: 'Balance',
            onTap: () {
              context.push('/balance');
            },
          ),
          _accountItem(
            icon: Icons.location_on,
            title: 'Address Book',
            onTap: () {
              context.push('/address-book');
            },
          ),

          _sectionTitle('Preferences'),
          _accountItem(
            icon: Icons.notifications,
            title: 'Notification Preferences',
            onTap: () {
              context.push('/notification-preferences');
            },
          ),
          _accountItem(
            icon: Icons.settings,
            title: 'Settings',
            onTap: () {
              context.push('/settings');
            },
          ),

          _sectionTitle('Support'),
          _accountItem(
            icon: Icons.help_outline,
            title: 'FAQ',
            onTap: () {
              context.push('/faq');
            },
          ),
          _accountItem(
            icon: Icons.support_agent,
            title: 'Customer Service',
            onTap: () {
              context.push('/customer-service');
            },
          ),
        ],
      ),
    );
  }
}

Widget _sectionTitle(String title) {
  return Padding(
    padding: const EdgeInsetsGeometry.fromLTRB(16, 16, 16, 8),
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
  required VoidCallback onTap,
}) {
  return ListTile(
    leading: Icon(icon, color: AppColors.primaryRed),
    title: Text(title),
    trailing: const Icon(Icons.chevron_right),
    onTap: onTap,
  );
}

class _ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          context.push('/profile');
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
                children: const [
                  Text(
                    'Guest User',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Tap to login',
                    style: TextStyle(color: AppColors.white),
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
