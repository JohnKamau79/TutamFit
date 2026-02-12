// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:tutam_fit/models/order_model.dart';

// class CheckoutService {
//   final  _firestore = FirebaseFirestore.instance;
  

//   Future<void> checkout(String userId) async {
//     final cartRef = _firestore.collection('cart').doc(userId);
//     final orderRef = _firestore.collection('order');

//     await _firestore.runTransaction((transaction) async {
//       final cartSnap = await transaction.get(cartRef);

//       if(!cartSnap.exists) {
//         throw Exception('Cart is empty');
//       }

//       final cartItems = cartSnap['items'] as List;

//       double total = 0.0;

//       final List<OrderItem> orderItems = [];

//       for(final item in cartItems) {
//         final productRef = _firestore.collection('product').doc(item['productId']);

//         final productSnap = await transaction.get(productRef);

//         if(!productSnap.exists) {
//           throw Exception('Product not found');
//         }

//         final int stock = productSnap['stock'];
//         final int quantity = item['quantity'] as int;
//         final double price = (productSnap['price'] as num).toDouble();

//         if(stock < quantity) {
//           throw Exception('Insufficient stock');
//         }

//         transaction.update(productRef, {
//           'stock': stock-quantity,
//         });

//         total +=price * quantity;

//         orderItems.add(
//           OrderItem(
//             productId: item['productId'], 
//             price: price, 
//             quantity: quantity,
//             ),
//         );
//       }

//       final order = OrderModel(
//         userId: userId, 
//         products: orderItems,
//         totalPrice: total,
//         currency: 'KES',
//         status: 'pending',
//         paymentMethod: 'mpesa',
//         createdAt: Timestamp.now(),
//         updatedAt: Timestamp.now(),
//       );

//       final newOrderRef = orderRef.doc();

//       transaction.set(newOrderRef, order.toJson());

//       transaction.delete(cartRef);
//     });
//   }
// }