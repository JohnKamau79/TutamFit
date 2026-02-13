import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutam_fit/providers/product_provider.dart';

class SearchbarWidget extends ConsumerStatefulWidget {
  const SearchbarWidget({super.key});

  @override
  ConsumerState<SearchbarWidget> createState() => _SearchbarWidgetState();
}

class _SearchbarWidgetState extends ConsumerState<SearchbarWidget> {
  Timer? _debounce;

  void _onSearchChanged(String query) {
    if(_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(searchQueryProvider.notifier).state = query;
    });
  }

  @override
  void dispose() {
    _debounce!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: _onSearchChanged,
      decoration: InputDecoration(
        hintText: 'Search Products...',
        prefixIcon: Icon(Icons.search),
        border: InputBorder.none,
      ),
    );
  }
}
