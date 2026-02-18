import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutam_fit/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  String _role = 'user';
  bool _loading = false;

  void _registerEmail() async {
    setState(() => _loading = true);
    try {
      await ref
          .read(authStateProvider.notifier)
          .registerEmail(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
            phone: _phoneController.text.trim(),
            city: _cityController.text.trim(),
            role: _role,
          );
      context.go('/main'); // go to Home after registration
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Registration failed: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  void _registerGoogle() async {
    setState(() => _loading = true);
    try {
      await ref.read(authStateProvider.notifier).loginGoogle();
      // go to Home after Google login
      final user = ref.read(authStateProvider);

      if (user != null &&
          (user.phone.isEmpty || user.city.isEmpty || user.role!.isEmpty)) {
        context.push('/complete-profile');
      } else {
        context.go('/main');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Google login failed: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
            ),
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(labelText: 'City'),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _role,
              items: const [
                DropdownMenuItem(value: 'user', child: Text('User')),
                DropdownMenuItem(value: 'admin', child: Text('Admin')),
              ],
              onChanged: (value) {
                if (value != null) _role = value;
              },
              decoration: const InputDecoration(labelText: 'Role'),
            ),
            const SizedBox(height: 16),
            _loading
                ? const CircularProgressIndicator()
                : Column(
                    children: [
                      ElevatedButton(
                        onPressed: _registerEmail,
                        child: const Text('Register'),
                      ),
                      ElevatedButton(
                        onPressed: _registerGoogle,
                        child: const Text('Register with Google'),
                      ),
                      TextButton(
                        onPressed: () => context.push('/login'),
                        child: const Text('Already have an account? Login'),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
