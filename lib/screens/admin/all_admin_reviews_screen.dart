import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutam_fit/models/review_model.dart';
import 'package:tutam_fit/providers/review_provider.dart';
import 'modern_card.dart';

class AllAdminReviewsScreen extends ConsumerWidget {
  const AllAdminReviewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewsAsync = ref.watch(allReviewsProvider);
    final repo = ref.watch(reviewRepositoryProvider);
    final theme = Theme.of(context);

    Future<void> confirmDelete(ReviewModel review) async {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete Review'),
          content: Text(
            'Are you sure you want to delete this review by ${review.userName}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        ),
      );

      if (result == true) {
        await repo.deleteReview(review.id!);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Review deleted')));
      }
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('All Reviews'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: theme.textTheme.bodyLarge?.color,
      ),
      body: reviewsAsync.when(
        data: (reviews) {
          if (reviews.isEmpty) {
            return Center(
              child: Text(
                'No reviews found',
                style: theme.textTheme.bodyMedium,
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              return ModernCard(
                title: review.userName,
                subtitle: review.comment,
                onDelete: () => confirmDelete(review),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Text('Error: $err', style: theme.textTheme.bodyMedium),
        ),
      ),
    );
  }
}
