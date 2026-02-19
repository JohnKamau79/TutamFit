import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutam_fit/providers/auth_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authStateProvider);
    if (user != null) {
      _phoneController.text = user.phone;
      _cityController.text = user.city;
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

      context.pop();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update profile: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider);
    final theme = Theme.of(context);

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('You must be logged in to view this screen.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.1),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Column(
                children: [
                  _readOnlyField("Name", user.name),
                  _readOnlyField("Email", user.email),
                  const SizedBox(height: 16),

                  _editableField(_phoneController, "Phone"),
                  _editableField(_cityController, "City"),

                  const SizedBox(height: 24),

                  _loading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _saveProfile,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text("Save Changes"),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _readOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: TextEditingController(text: value),
        readOnly: true,
        decoration: InputDecoration(labelText: label, filled: true),
      ),
    );
  }

  Widget _editableField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label, filled: true),
      ),
    );
  }
}
