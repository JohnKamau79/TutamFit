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
  String? selectedPayment; // 'mpesa' | 'stripe'  
  bool isLoading = false;  
  String mpesaPhone = '';  
  CardFieldInputDetails? card;  

  @override  
  Widget build(BuildContext context) {  
    final cartAsync = ref.watch(cartStreamProvider);  
    final cartRepo = ref.read(cartRepositoryProvider);  

    return Scaffold(  
      backgroundColor: Colors.grey[100],  
      appBar: AppBar(  
        backgroundColor: Colors.deepPurple,  
        title: const Text('Checkout'),  
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
                        // Cart Items (unchanged)  
                        Container(  
                          decoration: BoxDecoration(  
                            color: Colors.white,  
                            borderRadius: BorderRadius.circular(16),  
                            boxShadow: [  
                              BoxShadow(  
                                color: Colors.black12,  
                                blurRadius: 6,  
                                offset: Offset(0, 3),  
                              ),  
                            ],  
                          ),  
                          padding: const EdgeInsets.all(16),  
                          child: Column(  
                            crossAxisAlignment: CrossAxisAlignment.start,  
                            children: [  
                              const Text(  
                                'Your Cart',  
                                style: TextStyle(  
                                  fontSize: 18,  
                                  fontWeight: FontWeight.bold,  
                                ),  
                              ),  
                              const SizedBox(height: 12),  
                              ...cartItems.map(  
                                (item) => Padding(  
                                  padding: const EdgeInsets.symmetric(vertical: 8),  
                                  child: Row(  
                                    children: [  
                                      ClipRRect(  
                                        borderRadius: BorderRadius.circular(8),  
                                        child: Image.network(  
                                          item.image,  
                                          width: 60,  
                                          height: 60,  
                                          fit: BoxFit.cover,  
                                        ),  
                                      ),  
                                      const SizedBox(width: 12),  
                                      Expanded(  
                                        child: Column(  
                                          crossAxisAlignment: CrossAxisAlignment.start,  
                                          children: [  
                                            Text(  
                                              item.name,  
                                              style: const TextStyle(fontWeight: FontWeight.bold),  
                                            ),  
                                            Text('KES ${item.price} x${item.quantity}'),  
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

                        // Total (unchanged)  
                        Container(  
                          padding: const EdgeInsets.all(16),  
                          decoration: BoxDecoration(  
                            color: Colors.white,  
                            borderRadius: BorderRadius.circular(16),  
                            boxShadow: [  
                              BoxShadow(  
                                color: Colors.black12,  
                                blurRadius: 6,  
                                offset: Offset(0, 3),  
                              ),  
                            ],  
                          ),  
                          child: Row(  
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,  
                            children: [  
                              const Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),  
                              Text('KES ${total.toStringAsFixed(0)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),  
                            ],  
                          ),  
                        ),  
                        const SizedBox(height: 20),  

                        // Payment Section (unchanged except MPesa logic)  
                        Container(  
                          padding: const EdgeInsets.all(16),  
                          decoration: BoxDecoration(  
                            color: Colors.white,  
                            borderRadius: BorderRadius.circular(16),  
                            boxShadow: [  
                              BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),  
                            ],  
                          ),  
                          child: Column(  
                            crossAxisAlignment: CrossAxisAlignment.start,  
                            children: [  
                              const Text('Payment Method', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),  
                              const SizedBox(height: 12),  
                              DropdownButtonFormField<String>(  
                                initialValue: selectedPayment,  
                                decoration: const InputDecoration(border: OutlineInputBorder()),  
                                items: const [  
                                  DropdownMenuItem(value: 'mpesa', child: Text('M-Pesa')),  
                                  DropdownMenuItem(value: 'stripe', child: Text('Stripe')),  
                                ],  
                                onChanged: (val) => setState(() => selectedPayment = val),  
                              ),  
                              const SizedBox(height: 12),  
                              if (selectedPayment == 'mpesa')  
                                TextFormField(  
                                  decoration: const InputDecoration(labelText: 'Phone Number (+254)', border: OutlineInputBorder()),  
                                  keyboardType: TextInputType.phone,  
                                  onChanged: (val) => mpesaPhone = val,  
                                ),  
                              if (selectedPayment == 'stripe')  
                                CardField(onCardChanged: (c) => card = c, decoration: const InputDecoration(border: OutlineInputBorder())),  
                            ],  
                          ),  
                        ),  
                      ],  
                    ),  
                  ),  
                  const SizedBox(height: 16),  

                  // Place Order Button (only MPesa logic changed)  
                  SizedBox(  
                    width: double.infinity,  
                    child: ElevatedButton(  
                      style: ElevatedButton.styleFrom(  
                        padding: const EdgeInsets.symmetric(vertical: 16),  
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),  
                      ),  
                      onPressed: selectedPayment == null  
                          ? null  
                          : () async {  
                              setState(() => isLoading = true);  
                              try {  
                                bool paymentSuccess = false;  

                                if (selectedPayment == 'mpesa') {  
                                  if (mpesaPhone.isEmpty) throw Exception('Enter phone number');  
                                  paymentSuccess = await MpesaService().stkPush(  
                                    phoneNumber: mpesaPhone,  
                                    amount: total,  
                                  );  
                                } else if (selectedPayment == 'stripe') {  
                                  if (card == null || !card!.complete) throw Exception('Enter valid card details');  
                                  final paymentMethod = await Stripe.instance.createPaymentMethod(  
                                    params: PaymentMethodParams.card(paymentMethodData: PaymentMethodData()),  
                                  );  
                                  paymentSuccess = await StripeService().chargeCard(  
                                    paymentMethodId: paymentMethod.id,  
                                    amount: total,  
                                    currency: 'kes',  
                                  );  
                                }  

                                if (paymentSuccess) {  
                                  // Create order  
                                  final cartItemsList = ref.read(cartStreamProvider).value ?? [];  
                                  final currentUser = ref.read(authStateProvider);
                                  await ref.read(orderRepositoryProvider).createOrder(
                                    userName: currentUser!.name,
                                    cartItems: cartItemsList,  
                                    paymentMethod: selectedPayment!,  
                                    totalAmount: total,  
                                  );

                                  // Clear cart  
                                  for (var item in cartItemsList) {  
                                    await cartRepo.removeItem(item.productId);  
                                  }  

                                  if (!mounted) return;  
                                  ScaffoldMessenger.of(context).showSnackBar(  
                                    const SnackBar(content: Text('Order placed successfully')),  
                                  );  
                                  Navigator.pop(context);  
                                } else {  
                                  if (!mounted) return;  
                                  ScaffoldMessenger.of(context).showSnackBar(  
                                    const SnackBar(content: Text('Payment failed')),  
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
                          ? const CircularProgressIndicator(color: Colors.white)  
                          : const Text('Place Order', style: TextStyle(fontSize: 18)),
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
}