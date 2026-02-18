import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:tutam_fit/models/product_model.dart';
import 'package:tutam_fit/repositories/product_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ----------------------------
// Product Repository Provider
// ----------------------------
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository();
});

// ----------------------------
// CATEGORY STATE-PROVIDER
// ----------------------------
final selectedCategoryProvider = StateProvider<String>((ref) => 'all');

// ----------------------------
// SEARCH STATE-PROVIDER
// ----------------------------
final searchQueryProvider = StateProvider<String>((ref) => '');

// ----------------------------
// SEARCH HISTORY PROVIDER
// ----------------------------
final recentSearchesProvider =
    StateNotifierProvider<RecentSearchNotifier, List<String>>((ref) {
      return RecentSearchNotifier();
    });

class RecentSearchNotifier extends StateNotifier<List<String>> {
  RecentSearchNotifier() : super([]) {
    _load();
  }

  static const key = 'recent_searches';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getStringList(key) ?? [];
  }

  Future<void> addSearch(String query) async {
    query = query.trim();
    if (query.isEmpty) return;

    final updated = [
      query,
      ...state.where((s) => s != query),
    ].take(10).toList();
    state = updated;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, updated);
  }

  Future<void> clear() async {
    state = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}

// ----------------------------
// SORT LOGIC
// ----------------------------
enum ProductSort { latest, oldest, priceLow, priceHigh }

final productFilterProvider = StateProvider<ProductSort?>((ref) => null);
final minPriceProvider = StateProvider<double?>((ref) => null);
final maxPriceProvider = StateProvider<double?>((ref) => null);

// ----------------------------
// SEARCH + FILTER PROVIDER
// ----------------------------
final searchProductsStreamProvider =
    StreamProvider.autoDispose<List<ProductModel>>((ref) {
      final repo = ref.read(productRepositoryProvider);
      final searchQuery = ref.watch(searchQueryProvider).toLowerCase();
      final sortOption = ref.watch(productFilterProvider);
      final minPrice = ref.watch(minPriceProvider);
      final maxPrice = ref.watch(maxPriceProvider);

      return repo.streamAllProducts().map((products) {
        // Filter by search query
        List<ProductModel> filtered = products;
        if (searchQuery.isNotEmpty) {
          filtered = filtered
              .where((p) => p.name.toLowerCase().contains(searchQuery))
              .toList();
        }

        // Filter by price
        if (minPrice != null) {
          filtered = filtered.where((p) => p.price >= minPrice).toList();
        }
        if (maxPrice != null) {
          filtered = filtered.where((p) => p.price <= maxPrice).toList();
        }

        // Sorting
        if (sortOption != null) {
          switch (sortOption) {
            case ProductSort.latest:
              filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
              break;
            case ProductSort.oldest:
              filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
              break;
            case ProductSort.priceLow:
              filtered.sort((a, b) => a.price.compareTo(b.price));
              break;
            case ProductSort.priceHigh:
              filtered.sort((a, b) => b.price.compareTo(a.price));
              break;
          }
        }

        return filtered;
      });
    });

// ----------------------------
// HOME CATEGORY + SEARCH FILTER PROVIDER
// ----------------------------
final productsStreamProvider = StreamProvider.autoDispose<List<ProductModel>>((
  ref,
) {
  final repo = ref.read(productRepositoryProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase();

  Stream<List<ProductModel>> stream;

  if (selectedCategory == 'all') {
    stream = repo.streamAllProducts();
  } else {
    stream = repo.streamProductsByCategory(selectedCategory);
  }

  return stream.map((products) {
    // Filter by search query
    if (searchQuery.isNotEmpty) {
      products = products
          .where((p) => p.name.toLowerCase().contains(searchQuery))
          .toList();
    }
    return products;
  });
});

// ----------------------------
// ALL PRODUCTS STREAM
// ----------------------------
final allProductsStreamProvider = StreamProvider<List<ProductModel>>((ref) {
  final repo = ref.read(productRepositoryProvider);
  return repo.streamAllProducts();
});
