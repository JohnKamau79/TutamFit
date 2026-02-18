import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutam_fit/constants/app_colors.dart';
import 'package:tutam_fit/providers/auth_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  // String _role = 'user';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authStateProvider);
    if (user != null) {
      _phoneController.text = user.phone;
      _cityController.text = user.city;
      // _role = user.role;
    }
  }

  void _saveProfile() async {
    final user = ref.read(authStateProvider);
    if (user == null) return;

    setState(() => _loading = true);

    try {
      await ref
          .read(authStateProvider.notifier)
          .updateProfile(
            phone: _phoneController.text.trim(),
            city: _cityController.text.trim(),
            role: 'user',
          );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );

      context.pop(); // Go back to Account screen
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update profile: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider);

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          backgroundColor: AppColors.deepNavy,
        ),
        body: const Center(
          child: Text('You must be logged in to view this screen.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppColors.deepNavy,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildReadOnlyField('Name', user.name),
            _buildReadOnlyField('Email', user.email),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
            ),
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(labelText: 'City'),
            ),
            // const SizedBox(height: 8),
            // DropdownButtonFormField<String>(
            //   initialValue: _role,
            //   items: const [
            //     DropdownMenuItem(value: 'user', child: Text('User')),
            //     DropdownMenuItem(value: 'admin', child: Text('Admin')),
            //   ],
            //   onChanged: (value) {
            //     if (value != null) _role = value;
            //   },
            //   decoration: const InputDecoration(labelText: 'Role'),
            // ),
            const SizedBox(height: 16),
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _saveProfile,
                    child: const Text('Save Profile'),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextField(
        decoration: InputDecoration(labelText: label),
        controller: TextEditingController(text: value),
        readOnly: true,
      ),
    );
  }
}
