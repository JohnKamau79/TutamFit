import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Admin Panel',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: const [
            _ModernTile(
              title: 'Add Product',
              subtitle: 'Create new product',
              icon: Icons.add_box_rounded,
              routeName: '/add-product',
            ),
            _ModernTile(
              title: 'Add Category',
              subtitle: 'Create new category',
              icon: Icons.category_rounded,
              routeName: '/add-category',
            ),
            _ModernTile(
              title: 'All Products',
              subtitle: 'Manage inventory',
              icon: Icons.inventory_2_rounded,
              routeName: '/all-products',
            ),
            _ModernTile(
              title: 'All Reviews',
              subtitle: 'Customer feedback',
              icon: Icons.rate_review_rounded,
              routeName: '/all-admin-reviews',
            ),
            _ModernTile(
              title: 'All Orders',
              subtitle: 'Track purchases',
              icon: Icons.shopping_bag_rounded,
              routeName: '/all-orders',
            ),
            _ModernTile(
              title: 'All Users',
              subtitle: 'User management',
              icon: Icons.people_alt_rounded,
              routeName: '/all-users',
            ),
          ],
        ),
      ),
    );
  }
}

class _ModernTile extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String routeName;

  const _ModernTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.routeName,
  });

  @override
  State<_ModernTile> createState() => _ModernTileState();
}

class _ModernTileState extends State<_ModernTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () => context.push(widget.routeName),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 120),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F0FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  widget.icon,
                  size: 26,
                  color: const Color(0xFF3366FF),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.subtitle,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
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
