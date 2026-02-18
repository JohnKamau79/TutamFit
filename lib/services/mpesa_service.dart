import 'dart:convert';
import 'package:http/http.dart' as http;

class MpesaService {
  // 🔴 Replace with your sandbox credentials
  final String consumerKey = 'kLFRYs2fK6qgstpOs3LOCzPTr6H5SDpjJww5reNIRyVGJSox';
  final String consumerSecret = 'perCKS9gwQsyc7wohxhGCfWLpXsafAFfCcGQSRmR0It65jfDy1bGA8hqrnnhXkKc';
  final String passkey = 'bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919';
  final String shortcode = '174379';

  // 1️⃣ Get OAuth Token
  Future<String> _getAccessToken() async {
    final credentials =
        base64Encode(utf8.encode('$consumerKey:$consumerSecret'));

    final response = await http.get(
      Uri.parse(
          'https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials'),
      headers: {
        'Authorization': 'Basic $credentials',
      },
    );

    final body = jsonDecode(response.body);
    return body['access_token'];
  }

  // 2️⃣ Initiate STK Push
  Future<bool> stkPush({
    required String phoneNumber,
    required double amount,
  }) async {
    final token = await _getAccessToken();

    final timestamp = _generateTimestamp();
    final password =
        base64Encode(utf8.encode('$shortcode$passkey$timestamp'));

    final response = await http.post(
      Uri.parse(
          'https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "BusinessShortCode": shortcode,
        "Password": password,
        "Timestamp": timestamp,
        "TransactionType": "CustomerPayBillOnline",
        "Amount": amount.toInt(),
        "PartyA": phoneNumber,
        "PartyB": shortcode,
        "PhoneNumber": phoneNumber,
        "CallBackURL": "https://mydomain.com/callback", // ignored in sandbox for now
        "AccountReference": "TutamFit",
        "TransactionDesc": "Payment for order"
      }),
    );

    final body = jsonDecode(response.body);

    return body['ResponseCode'] == '0';
  }

  String _generateTimestamp() {
    final now = DateTime.now();
    return '${now.year}'
        '${now.month.toString().padLeft(2, '0')}'
        '${now.day.toString().padLeft(2, '0')}'
        '${now.hour.toString().padLeft(2, '0')}'
        '${now.minute.toString().padLeft(2, '0')}'
        '${now.second.toString().padLeft(2, '0')}';
  }
}