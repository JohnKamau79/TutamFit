import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutam_fit/screens/account/address_book_screen.dart';
import 'package:tutam_fit/screens/account/balance_screen.dart';
import 'package:tutam_fit/screens/account/customer_service_screen.dart';
import 'package:tutam_fit/screens/account/faq_screen.dart';
import 'package:tutam_fit/screens/account/notification_preferences_screen.dart';
import 'package:tutam_fit/screens/account/orders_screen.dart';
import 'package:tutam_fit/screens/account/profile_screen.dart';
import 'package:tutam_fit/screens/account/ratings_screen.dart';
import 'package:tutam_fit/screens/account/recently_viewed_screen.dart';
import 'package:tutam_fit/screens/account/reviews_screen.dart';
import 'package:tutam_fit/screens/account/settings_screen.dart';
import 'package:tutam_fit/screens/account/wishlist_screen.dart';
import 'package:tutam_fit/screens/auth/login_screen.dart';
import 'package:tutam_fit/screens/auth/signup_screen.dart';
import 'package:tutam_fit/screens/cart/checkout_screen.dart';
import 'package:tutam_fit/screens/cart/edit_cart_screen.dart';
import 'package:tutam_fit/screens/main_screen.dart';
import 'package:tutam_fit/screens/messaging/order_updates_screen.dart';
import 'package:tutam_fit/screens/messaging/support_chat_screen.dart';
import 'package:tutam_fit/screens/messaging/system_messages_screen.dart';
import 'package:tutam_fit/screens/products/product_details_screen.dart';
import 'package:tutam_fit/screens/products/product_filter_screen.dart';
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
      GoRoute(path: '/main', builder: (_, _) => MainScreen()),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            transitionDuration: const Duration(milliseconds: 300),
            child: const LoginScreen(),
            transitionsBuilder: (context, animation, _, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
      GoRoute(path: '/signup', builder: (_, _) => SignupScreen()),
      GoRoute(path: '/product', builder: (_, _) => ProductDetailsScreen()),
      GoRoute(
        path: '/product-filter',
        builder: (_, _) => ProductFilterScreen(),
      ),
      GoRoute(path: '/checkout', builder: (_, _) => CheckoutScreen()),
      GoRoute(path: '/cart-edit', builder: (_, _) => EditCartScreen()),
      GoRoute(path: '/orders', builder: (_, _) => OrdersScreen()),
      GoRoute(path: '/reviews', builder: (_, _) => ReviewsScreen()),
      GoRoute(
        path: '/recently-viewed',
        builder: (_, _) => RecentlyViewedScreen(),
      ),
      GoRoute(path: '/ratings', builder: (_, _) => RatingsScreen()),
      GoRoute(path: '/balance', builder: (_, _) => BalanceScreen()),
      GoRoute(path: '/address-book', builder: (_, _) => AddressBookScreen()),
      GoRoute(
        path: '/customer-service',
        builder: (_, _) => CustomerServiceScreen(),
      ),
      GoRoute(path: '/faq', builder: (_, _) => FaqScreen()),
      GoRoute(
        path: '/notification-preferences',
        builder: (_, _) => NotificationPreferencesScreen(),
      ),
      GoRoute(path: '/profile', builder: (_, _) => ProfileScreen()),
      GoRoute(path: '/settings', builder: (_, _) => SettingsScreen()),
      GoRoute(path: '/wishlist', builder: (_, _) => WishlistScreen()),
      GoRoute(path: '/order-updates', builder: (_, _) => OrderUpdatesScreen()),
      GoRoute(path: '/support-chat', builder: (_, _) => SupportChatScreen()),
      GoRoute(
        path: '/system-messages',
        builder: (_, _) => SystemMessagesScreen(),
      ),

      // GoRoute(
      //   path: '/product/:id',
      //   builder: (_, state) {
      //     ProductDetailsScreen( productId: state.params['id']!);
      //   },
    ],
  );
});
