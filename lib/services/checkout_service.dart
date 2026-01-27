// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:tutam_fit/models/order_model.dart';
// import 'package:tutam_fit/repositories/cart_repository.dart';
// import 'package:tutam_fit/repositories/order_repository.dart';

// class CheckoutService{
//   final CartRepository cartRepo;
//   final OrderRepository orderRepo;

//   CheckoutService({
//     required this.cartRepo,
//     required this.orderRepo,
//   });

//   Future<void> checkout(String userId) async {
//     final cartSnap = await FirebaseFirestore.instance
//         .collection('cart')
//         .doc(userId)
//         .get();

//         if(!cartSnap.exists) {
//           throw Exception('Cart is empty');
//         }

//         final total = await cartRepo.calculateTotal(userId);

//         final cartItems = cartSnap['items'] as List;

//         final List<OrderItem> orderItems = [];

//         for(final item in cartItems) {
//           final productSnap = await FirebaseFirestore.instance
//               .collection('product')
//               .doc(item['productId'])
//               .get();
          
//         orderItems.add(
//           OrderItem(
//             productId: item['productId'],
//             price: (productSnap['price'] as num).toDouble(),
//             quantity: item['quantity'],
//             ),
//         );
//         }

//         final order = OrderModel(
//           userId: userId, 
//           products: orderItems, 
//           totalPrice: total, 
//           currency: 'KES', 
//           status: 'pending', 
//           paymentMethod: 'mpesa', 
//           createdAt: Timestamp.now(), 
//           updatedAt: Timestamp.now(),
//         );

//         await orderRepo.addOrder(order);

//         await cartRepo.clearCart(userId);
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutam_fit/models/order_model.dart';

class CheckoutService {
  final  _firestore = FirebaseFirestore.instance;
  

  Future<void> checkout(String userId) async {
    final cartRef = _firestore.collection('cart').doc(userId);
    final orderRef = _firestore.collection('order');

    await _firestore.runTransaction((transaction) async {
      final cartSnap = await transaction.get(cartRef);

      if(!cartSnap.exists) {
        throw Exception('Cart is empty');
      }

      final cartItems = cartSnap['items'] as List;

      double total = 0.0;

      final List<OrderItem> orderItems = [];

      for(final item in cartItems) {
        final productRef = _firestore.collection('product').doc(item['productId']);

        final productSnap = await transaction.get(productRef);

        final price = (productSnap['price'] as num).toDouble();
        final quantity = item['quantity'] as int;

        total +=price * quantity;

        orderItems.add(
          OrderItem(
            productId: item['productId'], 
            price: price, 
            quantity: quantity,
            ),
        );
      }

      final order = OrderModel(
        userId: userId, 
        products: orderItems, 
        totalPrice: total, 
        currency: 'KES', 
        status: 'pending', 
        paymentMethod: 'mpesa', 
        createdAt: Timestamp.now(), 
        updatedAt: Timestamp.now(),
      );

      final newOrderRef = orderRef.doc();

      transaction.set(newOrderRef, order.toJson());

      transaction.delete(cartRef);
    });
  }
}