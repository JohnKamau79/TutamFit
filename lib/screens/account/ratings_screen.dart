import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutam_fit/providers/review_provider.dart';

class RatingsScreen extends ConsumerWidget {
  const RatingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("Please login to see your reviews.")),
      );
    }

    final reviewsAsync = ref.watch(userReviewsProvider(user.uid));

    return Scaffold(
      appBar: AppBar(title: const Text("My Ratings")),
      body: reviewsAsync.when(
        data: (reviews) {
          if (reviews.isEmpty) {
            return const Center(
              child: Text("You have not posted any reviews yet."),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withOpacity(0.15),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Product Name: ${review.productName}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: List.generate(
                        5,
                        (i) => Icon(
                          i < review.rating ? Icons.star : Icons.star_border,
                          color: theme.colorScheme.primary,
                          size: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      review.createdAt.toDate().toLocal().toString().split(
                        ' ',
                      )[0],
                      style: TextStyle(
                        color: theme.textTheme.bodySmall?.color?.withOpacity(
                          0.6,
                        ),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) =>
            const Center(child: Text("Error loading your reviews")),
      ),
    );
  }
}
