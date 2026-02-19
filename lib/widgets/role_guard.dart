import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutam_fit/providers/auth_provider.dart';

class RoleGuard extends ConsumerWidget {
  final Widget child;
  final String requiredRole;

  const RoleGuard({super.key, required this.child, required this.requiredRole});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider);

    if (user == null || user.role != requiredRole) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/login');
      });
      return const SizedBox.shrink();
    }

    return child;
  }
}
