import 'package:tutam_fit/repositories/order_repository.dart';

const Map<String, List<String>> allowedTransitions = {
  'pending': ['paid', 'cancelling'],
  'paid': ['processing', 'cancelled'],
  'processing': ['shipped'],
  'shipping': ['delivered'],
};

class OrderStatusService {
  final OrderRepository orderRepo;

  OrderStatusService(this.orderRepo);

  Future<void> changeStatus({
    required String orderId,
    required String currentStatus,
    required String nextStatus,
  }) async {
    final allowed = allowedTransitions[currentStatus] ?? [];

    if (!allowed.contains(nextStatus)) {
      throw Exception('Invalid status transaction');
    }

    await orderRepo.updateOrderStatus(orderId, nextStatus);
  }
}
