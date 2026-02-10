import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tutam_fit/constants/app_colors.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.deepNavy,
        title: Title(
          color: AppColors.deepNavy,
          child: Center(
            child: Text(
              'Messaging Center',
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      // BODY
      body: Column(
        children: [
          _MessageTile(
            icon: Icons.receipt_long,
            title: 'Order Updates',
            subtitle: 'Track orders and delivery status',
            onTap: () => context.push('/order-updates'),
          ),
          _MessageTile(
            icon: Icons.campaign,
            title: 'System Messages',
            subtitle: 'Promotions and announcements',
            onTap: () => context.push('/system-messages'),
          ),
          _MessageTile(
            icon: Icons.support_agent,
            title: 'Support Chat',
            subtitle: 'Talk to TutamFit support',
            onTap: () => context.push('/support-chat'),
          ),
        ],
      ),
    );
  }
}

class _MessageTile extends StatelessWidget {
  const _MessageTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.darkGray)),
          ),
          child: Row(
            children: [
              Icon(icon, size: 32, color: AppColors.vibrantOrange),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(color: AppColors.limeGreen),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
