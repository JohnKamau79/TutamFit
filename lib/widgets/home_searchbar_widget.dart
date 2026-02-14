import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeSearchbarWidget extends ConsumerStatefulWidget {
  const HomeSearchbarWidget({super.key});

  @override
  ConsumerState<HomeSearchbarWidget> createState() => _HomeSearchbarWidgetState();
}

class _HomeSearchbarWidgetState extends ConsumerState<HomeSearchbarWidget> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      onTap: () {
        context.push('/search');
      },
      decoration: InputDecoration(
        hintText: 'Search Products...',
        prefixIcon: Icon(Icons.search),
        border: InputBorder.none,
        contentPadding: EdgeInsets.all(12),
      ),
    );
  }
}
