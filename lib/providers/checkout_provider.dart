import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutam_fit/providers/cart_provider.dart';
import 'package:tutam_fit/providers/order_provider.dart';
import 'package:tutam_fit/services/checkout_service.dart';

final checkoutServiceProvider = Provider<CheckoutService>((ref) {
  return CheckoutService(
    cartRepo: ref.read(cartRepositoryProvider), 
    orderRepo: ref.read(orderRepositoryProvider),
    );
});