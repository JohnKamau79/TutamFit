import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutam_fit/constants/app_colors.dart';
import 'package:tutam_fit/providers/cart_provider.dart';
import 'package:tutam_fit/screens/tabs/account_screen.dart';
import 'package:tutam_fit/screens/tabs/cart_screen.dart';
import 'package:tutam_fit/screens/tabs/category_screen.dart';
import 'package:tutam_fit/screens/tabs/home_screen.dart';
import 'package:tutam_fit/screens/tabs/message_screen.dart';

class MainScreen extends StatefulWidget {
  final int index;
  const MainScreen({super.key, required this.index});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index;
  }

  final List<Widget> screens = const [
    HomeScreen(),
    CategoryScreen(),
    MessageScreen(),
    CartScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.deepNavy,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: AppColors.vibrantOrange,
          unselectedItemColor: AppColors.white,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.category_rounded),
              label: 'Category',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline_rounded),
              label: 'Message',
            ),
            BottomNavigationBarItem(
              icon: Consumer(
                builder: (context, ref, _) {
                  final user = FirebaseAuth.instance.currentUser;

                  if (user == null) {
                    return const Icon(Icons.shopping_cart_outlined);
                  }

                  final cartAsync = ref.watch(cartStreamProvider);

                  return cartAsync.when(
                    data: (cartItems) {
                      final count = cartItems.length;

                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Icon(Icons.shopping_cart_outlined),
                          if (count > 0)
                            Positioned(
                              right: -8,
                              top: -6,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                  color: AppColors.vibrantOrange,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 20,
                                  minHeight: 20,
                                ),
                                child: Center(
                                  child: Text(
                                    count.toString(),
                                    style: const TextStyle(
                                      color: AppColors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                    loading: () => const Icon(Icons.shopping_cart_outlined),
                    error: (_, _) => const Icon(Icons.shopping_cart_outlined),
                  );
                },
              ),
              label: 'Cart',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Account',
            ),
          ],
        ),
      ),
    );
  }
}
