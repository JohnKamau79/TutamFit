import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutam_fit/providers/auth_provider.dart';

class CompleteProfileScreen extends ConsumerStatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  ConsumerState<CompleteProfileScreen> createState() =>
      _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends ConsumerState<CompleteProfileScreen> {
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  String _role = 'user';
  bool _loading = false;

  void _saveProfile() async {
    setState(() => _loading = true);

    try {
      await ref
          .read(authStateProvider.notifier)
          .updateProfile(
            phone: _phoneController.text,
            city: _cityController.text,
            role: _role,
          );

      context.go('/main');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update profile: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    final user = ref.read(authStateProvider)!;
    _phoneController.text = user.phone;
    _cityController.text = user.city;
    _role = user.role!;
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complete Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
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
}
