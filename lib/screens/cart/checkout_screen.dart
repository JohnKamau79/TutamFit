import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:tutam_fit/providers/auth_provider.dart';
import 'package:tutam_fit/providers/cart_provider.dart';
import 'package:tutam_fit/providers/order_provider.dart';
import 'package:tutam_fit/services/mpesa_service.dart';
import 'package:tutam_fit/services/stripe_service.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  String? selectedPayment;
  bool isLoading = false;
  String mpesaPhone = '';
  CardFieldInputDetails? card;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cartAsync = ref.watch(cartStreamProvider);
    final cartRepo = ref.read(cartRepositoryProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: cartAsync.when(
        data: (cartItems) {
          if (cartItems.isEmpty) {
            return const Center(child: Text('Your cart is empty'));
          }

          double total = cartItems.fold(
            0,
            (sum, item) => sum + item.price * item.quantity,
          );

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        _cardContainer(
                          theme,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your Cart',
                                style: theme.textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ...cartItems.map(
                                (item) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: CachedNetworkImage(
                                          imageUrl: item.image,
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.name,
                                              style: theme.textTheme.bodyMedium!
                                                  .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            Text(
                                              'KES ${item.price} x${item.quantity}',
                                              style: theme.textTheme.bodySmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        _cardContainer(
                          theme,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total',
                                style: theme.textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'KES ${total.toStringAsFixed(0)}',
                                style: theme.textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        _cardContainer(
                          theme,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Payment Method',
                                style: theme.textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              DropdownButtonFormField<String>(
                                value: selectedPayment,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'mpesa',
                                    child: Text('M-Pesa'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'stripe',
                                    child: Text('Stripe'),
                                  ),
                                ],
                                onChanged: (val) =>
                                    setState(() => selectedPayment = val),
                              ),
                              const SizedBox(height: 12),
                              if (selectedPayment == 'mpesa')
                                TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: 'Phone Number (+254)',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.phone,
                                  onChanged: (val) => mpesaPhone = val,
                                ),
                              if (selectedPayment == 'stripe')
                                CardField(
                                  onCardChanged: (c) => card = c,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: selectedPayment == null
                          ? null
                          : () async {
                              setState(() => isLoading = true);
                              try {
                                bool paymentSuccess = false;

                                if (selectedPayment == 'mpesa') {
                                  if (mpesaPhone.isEmpty) {
                                    throw Exception('Enter phone number');
                                  }
                                  paymentSuccess = await MpesaService().stkPush(
                                    phoneNumber: mpesaPhone,
                                    amount: total,
                                  );
                                } else if (selectedPayment == 'stripe') {
                                  if (card == null || !card!.complete) {
                                    throw Exception('Enter valid card details');
                                  }
                                  final paymentMethod = await Stripe.instance
                                      .createPaymentMethod(
                                        params: PaymentMethodParams.card(
                                          paymentMethodData:
                                              PaymentMethodData(),
                                        ),
                                      );
                                  paymentSuccess = await StripeService()
                                      .chargeCard(
                                        paymentMethodId: paymentMethod.id,
                                        amount: total,
                                        currency: 'kes',
                                      );
                                }

                                if (paymentSuccess) {
                                  final cartItemsList =
                                      ref.read(cartStreamProvider).value ?? [];
                                  final currentUser = ref.read(
                                    authStateProvider,
                                  );

                                  await ref
                                      .read(orderRepositoryProvider)
                                      .createOrder(
                                        userName: currentUser!.name,
                                        cartItems: cartItemsList,
                                        paymentMethod: selectedPayment!,
                                        totalAmount: total,
                                      );

                                  for (var item in cartItemsList) {
                                    await cartRepo.removeItem(item.productId);
                                  }

                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Order placed successfully',
                                      ),
                                    ),
                                  );
                                  Navigator.pop(context);
                                } else {
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Payment failed'),
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: $e')),
                                );
                              } finally {
                                setState(() => isLoading = false);
                              }
                            },
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(
                              'Place Order',
                              style: TextStyle(fontSize: 18),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error loading cart: $e')),
      ),
    );
  }

  Widget _cardContainer(ThemeData theme, {required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}
