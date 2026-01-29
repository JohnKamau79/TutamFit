import 'package:cloud_firestore/cloud_firestore.dart';

class MpesaRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<void> markPaymentInitiated(String orderId) async {
    await _firestore.collection('order').doc(orderId).update({
      'paymentStatus': 'initiated',
      'updatedAt': Timestamp.now(),
    });
  }

  Future<void>  markPaymentSuccess({ required String orderId, required String paymentRef }) async{
    await _firestore.collection('order').doc(orderId).update({
      'paymentStatus': 'success',
      'paymentRef': paymentRef,
      'status': 'paid',
      'updatedAt': Timestamp.now(),
    });
  }

  Future<void> markPaymentFailed(String orderId) async {
    await _firestore.collection('order').doc(orderId).update({
      'paymentStatus': 'failed',
      'updatedAt': Timestamp.now(),
    });
  }
}