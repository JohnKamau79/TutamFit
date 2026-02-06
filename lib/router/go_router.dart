import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutam_fit/screens/auth/login_screen.dart';
import 'package:tutam_fit/screens/auth/signup_screen.dart';
import 'package:tutam_fit/screens/home_screen.dart';
import 'package:tutam_fit/screens/splash_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: SplashScreen(),
          transitionDuration: Duration(seconds: 3),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(path: '/home', builder: (_, _) => HomeScreen()),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            transitionDuration: const Duration(milliseconds: 300),
            child: const LoginScreen(),
            transitionsBuilder: (context, animation, _, child) {
              return FadeTransition(
                opacity: animation,
                child: child,);
            },
            );
        },
      ),
      GoRoute(
        path: '/signup',
        builder: (_, _) => SignupScreen(),
      ),
      // GoRoute(
      //   path: '/product/:id',
      //   builder: (_, state) {
      //     ProductDetailsScreen( productId: state.params['id']!);
      //   },
      // ),
      // GoRoute(
      //   path: '/cart',
      //   builder: (_, _) => CartScreen(),
      // ),
      // GoRoute(
      //   path: '/checkout',
      //   builder: (_, _) => CheckoutScreen(),
      // ),
      // GoRoute(
      //   path: '/orders',
      //   builder: (_, _) => OrdersScreen(),
      // ),
      // GoRoute(
      //   path: '/profile',
      //   builder: (_, _) => ProfileScreen(),
      // ),
    ],
  );
});
