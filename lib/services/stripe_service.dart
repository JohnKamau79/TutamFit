import 'dart:convert';
import 'package:http/http.dart' as http;

class StripeService {
  final String secretKey = '<YOUR_STRIPE_SECRET_KEY>';

  Future<bool> chargeCard({
    required String paymentMethodId,
    required double amount,
    required String currency,
  }) async {
    final url = Uri.parse('https://api.stripe.com/v1/payment_intents');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $secretKey',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'amount': (amount * 100).toInt().toString(), // cents
        'currency': currency,
        'payment_method': paymentMethodId,
        'confirm': 'true',
      },
    );

    final body = jsonDecode(response.body);
    return body['status'] == 'succeeded';
  }
}
