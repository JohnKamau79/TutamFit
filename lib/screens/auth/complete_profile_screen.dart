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

  @override
  void initState() {
    super.initState();
    final user = ref.read(authStateProvider)!;
    _phoneController.text = user.phone;
    _cityController.text = user.city;
    _role = user.role ?? 'user';
  }

  void _saveProfile() async {
    setState(() => _loading = true);

    try {
      await ref
          .read(authStateProvider.notifier)
          .updateProfile(
            phone: _phoneController.text.trim(),
            city: _cityController.text.trim(),
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Text(
                "Complete Your Profile",
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),

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
                    _buildField(_phoneController, "Phone"),
                    _buildField(_cityController, "City"),
                    const SizedBox(height: 12),

                    DropdownButtonFormField<String>(
                      value: _role,
                      decoration: const InputDecoration(
                        labelText: "Role",
                        filled: true,
                      ),
                      items: const [
                        DropdownMenuItem(value: "user", child: Text("User")),
                        DropdownMenuItem(value: "admin", child: Text("Admin")),
                      ],
                      onChanged: (v) => _role = v ?? "user",
                    ),

                    const SizedBox(height: 24),

                    _loading
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _saveProfile,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text("Save Profile"),
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label, filled: true),
      ),
    );
  }
}
