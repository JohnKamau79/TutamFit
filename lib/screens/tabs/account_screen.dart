import 'package:flutter/material.dart';
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
          _accountItem(Icons.favorite, 'Wishlist'),
          _accountItem(Icons.shopping_bag, 'My Orders'),
          _accountItem(Icons.star, 'Ratings'),
          _accountItem(Icons.rate_review, 'Reviews'),
          _accountItem(Icons.history, 'Recently Viewed'),

          _sectionTitle('Payments & Addresses'),
          _accountItem(Icons.account_balance_wallet, 'Balance'),
          _accountItem(Icons.location_on, 'Address Book'),

          _sectionTitle('Preferences'),
          _accountItem(Icons.notifications, 'Notification Preferences'),
          _accountItem(Icons.settings, 'Settings'),

          _sectionTitle('Support'),
          _accountItem(Icons.help_outline, 'FAQ'),
          _accountItem(Icons.support_agent, 'Customer Service'),
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

Widget _accountItem(IconData icon, String title) {
  return ListTile(
    leading: Icon(icon, color: AppColors.primaryRed),
    title: Text(title),
    trailing: const Icon(Icons.chevron_right),
    onTap: () {},
  );
}

class _ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
              Text('Tap to login', style: TextStyle(color: AppColors.white)),
            ],
          ),
        ],
      ),
    );
  }
}
