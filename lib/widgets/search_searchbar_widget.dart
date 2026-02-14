import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
import 'package:tutam_fit/providers/product_provider.dart';

class SearchSearchbarWidget extends ConsumerStatefulWidget {
  final void Function(String)? onSearchTap;
  const SearchSearchbarWidget({super.key, this.onSearchTap});

  @override
  ConsumerState<SearchSearchbarWidget> createState() =>
      _SearchSearchbarWidgetState();
}

class _SearchSearchbarWidgetState extends ConsumerState<SearchSearchbarWidget> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      ref.read(searchQueryProvider.notifier).state = value;
    });
  }

  void setText(String value) {
    _controller.text = value;
    ref.read(searchQueryProvider.notifier).state = value;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = ref.watch(searchQueryProvider);
    return TextField(
      controller: _controller,
      autofocus: true,
      onChanged: _onSearchChanged,
      decoration: InputDecoration(
        hintText: 'Search Products...',
        border: InputBorder.none,
        contentPadding: EdgeInsets.all(12),
        suffixIcon: IconButton(
          onPressed: searchQuery.isNotEmpty
              ? () {
                  final query = _controller.text.trim();
                  if (query.isEmpty) return;
                  ref.read(recentSearchesProvider.notifier).addSearch(query);

                  if (widget.onSearchTap != null) {
                    widget.onSearchTap!(query);
                  }

                  // context.push('/search-filter-screen');
                }
              : null,
          icon: Icon(Icons.search),
        ),
      ),
    );
  }
}
