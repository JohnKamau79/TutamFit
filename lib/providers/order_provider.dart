import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order_model.dart';
import '../repositories/order_repository.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepository();
});

final orderProvider = StreamProvider.family<List<OrderModel>, String>((
  ref,
  uid,
) {
  final repo = ref.read(orderRepositoryProvider);
  return repo.getOrderByUser(uid);
});
