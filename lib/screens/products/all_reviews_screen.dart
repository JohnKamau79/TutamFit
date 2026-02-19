import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutam_fit/providers/review_provider.dart';

class AllReviewsScreen extends ConsumerWidget {
  const AllReviewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewsAsync = ref.watch(allReviewsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('All Reviews'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: theme.textTheme.titleLarge?.color,
      ),
      body: reviewsAsync.when(
        data: (reviews) {
          if (reviews.isEmpty) {
            return Center(
              child: Text(
                "No reviews yet.",
                style: TextStyle(color: theme.textTheme.bodyLarge?.color),
              ),
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
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User
                    Text(
                      "User: ${review.userId.substring(0, 6)}",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Stars
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

                    // Comment
                    Text(
                      review.comment,
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Date
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
        error: (err, stack) => Center(
          child: Text(
            "Error loading reviews",
            style: TextStyle(color: theme.colorScheme.error),
          ),
        ),
      ),
    );
  }
}
