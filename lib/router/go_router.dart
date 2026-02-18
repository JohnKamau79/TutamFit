import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutam_fit/models/product_model.dart';
import 'package:tutam_fit/screens/account/address_book_screen.dart';
import 'package:tutam_fit/screens/account/balance_screen.dart';
import 'package:tutam_fit/screens/account/customer_service_screen.dart';
import 'package:tutam_fit/screens/account/faq_screen.dart';
import 'package:tutam_fit/screens/account/notification_preferences_screen.dart';
import 'package:tutam_fit/screens/account/orders_screen.dart';
import 'package:tutam_fit/screens/account/profile_screen.dart';
import 'package:tutam_fit/screens/account/ratings_screen.dart';
import 'package:tutam_fit/screens/account/reviews_screen.dart';
import 'package:tutam_fit/screens/account/settings_screen.dart';
import 'package:tutam_fit/screens/account/wishlist_screen.dart';
import 'package:tutam_fit/screens/admin/all_orders_screen.dart';
import 'package:tutam_fit/screens/admin/all_products_screen.dart';
import 'package:tutam_fit/screens/admin/all_admin_reviews_screen.dart';
import 'package:tutam_fit/screens/admin/all_users_screen.dart';
import 'package:tutam_fit/screens/admin/update_product_screen.dart';
import 'package:tutam_fit/screens/admin/admin_dashboard_screen.dart';
import 'package:tutam_fit/screens/auth/complete_profile_screen.dart';
import 'package:tutam_fit/screens/cart/checkout_screen.dart';
import 'package:tutam_fit/screens/cart/edit_cart_screen.dart';
import 'package:tutam_fit/screens/forms/add_review_screen.dart';
import 'package:tutam_fit/screens/forms/add_category_screen.dart';
import 'package:tutam_fit/screens/forms/add_product_screen.dart';
import 'package:tutam_fit/screens/auth/login_screen.dart';
import 'package:tutam_fit/screens/auth/register_screen.dart';
import 'package:tutam_fit/screens/main_screen.dart';
import 'package:tutam_fit/screens/messaging/order_updates_screen.dart';
import 'package:tutam_fit/screens/messaging/support_chat_screen.dart';
import 'package:tutam_fit/screens/messaging/system_messages_screen.dart';
import 'package:tutam_fit/screens/products/all_reviews_screen.dart';
import 'package:tutam_fit/screens/products/product_details_screen.dart';
import 'package:tutam_fit/screens/products/product_filter_screen.dart';
import 'package:tutam_fit/screens/search/search_filter_screen.dart';
import 'package:tutam_fit/screens/search/search_screen.dart';
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
      GoRoute(path: '/admin', builder: (_, _) => AdminDashboardScreen()),
      GoRoute(path: '/admin', builder: (_, _) => AdminDashboardScreen()),
      GoRoute(path: '/add-product', builder: (_, _) => AddProductScreen()),
      GoRoute(
        path: '/update-product',
        builder: (context, state) {
          final product = state.extra as ProductModel;
          return UpdateProductScreen(product: product);
        },
      ),
      GoRoute(path: '/add-category', builder: (_, _) => AddCategoryScreen()),
      GoRoute(path: '/all-products', builder: (_, _) => AllProductsScreen()),
      GoRoute(path: '/all-reviews', builder: (_, _) => AllReviewsScreen()),
      GoRoute(
        path: '/all-admin-reviews',
        builder: (_, _) => AllAdminReviewsScreen(),
      ),
      GoRoute(
        path: '/add-review',
        builder: (context, state) {
          final extra = state.extra as Map<String, String>;
          final productId = extra['productId']!;
          final productName = extra['productName']!;
          return AddReviewScreen(
            productId: productId,
            productName: productName,
          );
        },
      ),
      GoRoute(path: '/all-orders', builder: (_, _) => AllOrdersScreen()),
      GoRoute(path: '/all-users', builder: (_, _) => AllUsersScreen()),
      GoRoute(path: '/login', builder: (_, _) => LoginScreen()),
      GoRoute(path: '/register', builder: (_, _) => RegisterScreen()),
      GoRoute(
        path: '/complete-profile',
        builder: (_, _) => CompleteProfileScreen(),
      ),
      GoRoute(
        path: '/product-details',
        builder: (context, state) {
          final product = state.extra as ProductModel;

          return ProductDetailsScreen(product: product);
        },
      ),
      GoRoute(path: '/search', builder: (_, _) => SearchScreen()),
      GoRoute(
        path: '/search-filter-screen',
        builder: (_, _) => SearchFilterScreen(),
      ),
      GoRoute(
        path: '/product-filter',
        builder: (_, _) => ProductFilterScreen(),
      ),
      GoRoute(path: '/checkout', builder: (_, _) => CheckoutScreen()),
      GoRoute(path: '/cart-edit', builder: (_, _) => EditCartScreen()),
      GoRoute(path: '/user-orders', builder: (_, _) => OrdersScreen()),
      GoRoute(path: '/user-reviews', builder: (_, _) => MyReviewsScreen()),
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
    ],
  );
});
