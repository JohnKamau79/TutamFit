import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutam_fit/providers/product_provider.dart';

class FilterListWidget extends ConsumerWidget {
  const FilterListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: DropdownButton<ProductSort>(
            dropdownColor: const Color.fromARGB(255, 255, 165, 56),
            value: ref.watch(productFilterProvider),
            hint: Text('Sort'),
            items: ProductSort.values.map((e) {
              return DropdownMenuItem(value: e, child: Text(e.name));
            }).toList(),
            onChanged: (val) {
              ref.read(productFilterProvider.notifier).state = val;
            },
          ),
        ),
        SizedBox(width: 16),
      ],
    );
  }
}
