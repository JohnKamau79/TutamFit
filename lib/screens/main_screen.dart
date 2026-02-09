import 'package:flutter/material.dart';
import 'package:tutam_fit/constants/app_colors.dart';
import 'package:tutam_fit/screens/tabs/account_screen.dart';
import 'package:tutam_fit/screens/tabs/cart_screen.dart';
import 'package:tutam_fit/screens/tabs/category_screen.dart';
import 'package:tutam_fit/screens/tabs/home_screen.dart';
import 'package:tutam_fit/screens/tabs/message_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int _currentIndex = 0;

  final List<Widget> screens = [
    HomeScreen(),
    CategoryScreen(),
    MessageScreen(),
    CartScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: AppColors.deepNavy,
        selectedItemColor: AppColors.limeGreen,
        unselectedItemColor: AppColors.white,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Category',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Message',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_rounded),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}