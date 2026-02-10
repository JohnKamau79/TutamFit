import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Product Details'),
            SizedBox(height: 4),
            TextButton(
              onPressed: () {
                context.push('/checkout');
              },
              child: Text('Order Now'),
            ),
          ],
        ),
      ),
    );
  }
}
