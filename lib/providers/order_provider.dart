import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutam_fit/models/order_model.dart';
import 'package:tutam_fit/repositories/order_repository.dart';
import 'auth_provider.dart';

// Order repository provider
final orderRepositoryProvider = Provider((ref) => OrderRepository());

// Orders stream provider
final userOrdersStreamProvider = StreamProvider<List<OrderModel>>((ref) {
  final user = ref.watch(authStateProvider); // watch current auth state
  if (user == null || user.id == null) return const Stream.empty();

  final repo = ref.watch(orderRepositoryProvider);
  return repo.streamUserOrders(user.id!);
});

final allOrdersStreamProvider = StreamProvider<List<OrderModel>>((ref) {
  final repo = ref.watch(orderRepositoryProvider);
  return repo.streamAllOrders();
});

// Delete provider
final deleteOrderProvider = Provider<DeleteOrder>((ref) {
  final repo = ref.watch(orderRepositoryProvider);
  return DeleteOrder(repo);
});

class DeleteOrder {
  final OrderRepository _repo;
  DeleteOrder(this._repo);

  Future<void> call(String orderId) async {
    await _repo.deleteOrder(orderId);
  }
}
