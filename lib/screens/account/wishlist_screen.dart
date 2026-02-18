import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutam_fit/providers/wishlist_provider.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistAsync = ref.watch(wishlistStreamProvider);
    final wishlistRepo = ref.read(wishlistRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist')),
      body: wishlistAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('No items in wishlist'));
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];

              return ListTile(
                leading: Image.network(
                  item.image,
                  width: 60,
                  fit: BoxFit.cover,
                ),
                title: Text(item.name),
                subtitle: Text('KES ${item.price}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    wishlistRepo.removeFromWishlist(item.productId);
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => const Center(child: Text('Error loading wishlist')),
      ),
    );
  }
}
