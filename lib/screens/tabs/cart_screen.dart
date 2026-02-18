import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutam_fit/constants/app_colors.dart';
import 'package:tutam_fit/providers/cart_provider.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartAsync = ref.watch(cartStreamProvider);
    final cartRepo = ref.read(cartRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Cart')),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 14),
        child: ElevatedButton(onPressed: () {context.push('/checkout');}, style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryRed), child: const Text('Checkout', style: TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.bold),),),
      ),
      body: cartAsync.when(
        data: (cartItems) {
          if (cartItems.isEmpty) {
            return const Center(child: Text('Cart is empty'));
          }

          double total = 0;
          for (var item in cartItems) {
            total += item.price * item.quantity;
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];

                    return ListTile(
                      leading: Image.network(
                        item.image,
                        width: 60,
                        fit: BoxFit.cover,
                      ),
                      title: Text(item.name),
                      subtitle: Text('KES ${item.price}  x${item.quantity}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              cartRepo.decreaseQuantity(
                                item.productId,
                                item.quantity,
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              cartRepo.increaseQuantity(item.productId);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              cartRepo.removeItem(item.productId);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Total: KES ${total.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => const Center(child: Text('Error loading cart')),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:tutam_fit/constants/app_colors.dart';

// class CartScreen extends StatelessWidget {
//   const CartScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.deepNavy,
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'My Cart',
//               style: TextStyle(
//                 color: AppColors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Row(
//               children: [
//                 TextButton.icon(
//                   onPressed: () {
//                     context.push('/cart-edit');
//                   },
//                   label: Text(
//                     'Edit',
//                     style: TextStyle(
//                       color: AppColors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   icon: Icon(
//                     Icons.edit,
//                     color: AppColors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//       // BODY
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: 3,
//               itemBuilder: (context, index) => _CartItemTile(),
//             ),
//           ),
//           _CartSummary(),
//         ],
//       ),
//     );
//   }
// }

// class _CartItemTile extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Row(
//           children: [
//             Checkbox(
//               value: true,
//               onChanged: (value) {},
//               activeColor: AppColors.primaryRed,
//             ),
//             Container(
//               width: 70,
//               height: 70,
//               color: AppColors.limeGreen,
//               child: const Icon(Icons.fitness_center),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: const [
//                   Text(
//                     'Dumbbel 10kg',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 4),
//                   Text('KES 2,500'),
//                 ],
//               ),
//             ),
//             Row(
//               children: [
//                 IconButton(
//                   onPressed: () {},
//                   icon: const Icon(
//                     Icons.remove_circle_outline,
//                     color: AppColors.primaryRed,
//                   ),
//                 ),
//                 const Text('1'),
//                 IconButton(
//                   onPressed: () {},
//                   icon: const Icon(
//                     Icons.add_circle_outline,
//                     color: AppColors.vibrantOrange,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _CartSummary extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(30),
//       decoration: const BoxDecoration(
//         border: Border(top: BorderSide(color: AppColors.limeGreen)),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: const [
//               Text(
//                 'Total',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               Text(
//                 '7,500',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primaryRed,
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//               ),
//               onPressed: () {
//                 context.push('/checkout');
//               },
//               child: const Text(
//                 'Checkout',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: AppColors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
