import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutam_fit/providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  // EMAIL/PASSWORD LOGIN
  void _loginEmail() async {
    setState(() => _loading = true);
    try {
      await ref
          .read(authStateProvider.notifier)
          .loginEmail(_emailController.text.trim(), _passwordController.text);

      context.go('/main'); // Go to Home after login
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login failed: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  // GOOGLE LOGIN
  void _loginGoogle() async {
    setState(() => _loading = true);
    try {
      await ref.read(authStateProvider.notifier).loginGoogle();
      final user = ref.read(authStateProvider);

      // Check if profile is complete
      if (user != null &&
          (user.phone.isEmpty || user.city.isEmpty || user.role!.isEmpty)) {
        context.push('/complete-profile'); // Redirect to complete profile
      } else {
        context.go('/main'); // Go to Home if profile complete
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            _loading
                ? const CircularProgressIndicator()
                : Column(
                    children: [
                      ElevatedButton(
                        onPressed: _loginEmail,
                        child: const Text('Login'),
                      ),
                      ElevatedButton(
                        onPressed: _loginGoogle,
                        child: const Text('Login with Google'),
                      ),
                      TextButton(
                        onPressed: () => context.push('/register'),
                        child: const Text('Don’t have an account? Register'),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
