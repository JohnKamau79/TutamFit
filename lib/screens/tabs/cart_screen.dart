// cart_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tutam_fit/providers/cart_provider.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cartAsync = ref.watch(cartStreamProvider);
    final cartRepo = ref.read(cartRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        centerTitle: true,
        title: Text(
          'My Cart',
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: cartAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Text(
                'Your cart is empty',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.disabledColor,
                ),
              ),
            );
          }

          double total = 0;
          for (var item in items) {
            total += item.price * item.quantity;
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Card(
                      color: theme.cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: item.image,
                            width: 55,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          item.name,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'KES ${item.price}  x${item.quantity}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.remove,
                                color: theme.disabledColor,
                              ),
                              onPressed: () => cartRepo.decreaseQuantity(
                                item.productId,
                                item.quantity,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.add,
                                color: theme.colorScheme.secondary,
                              ),
                              onPressed: () =>
                                  cartRepo.increaseQuantity(item.productId),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: theme.colorScheme.error,
                              ),
                              onPressed: () {
                                cartRepo.removeItem(item.productId);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      'Item removed from cart',
                                    ),
                                    backgroundColor: theme.colorScheme.error,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                color: theme.cardColor,
                child: Column(
                  children: [
                    Text(
                      'Total: KES ${total.toStringAsFixed(0)}',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.secondary,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: () => context.push('/checkout'),
                        child: Text(
                          'Checkout',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSecondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
          child: Text(
            'Error loading cart',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ),
      ),
    );
  }
}
