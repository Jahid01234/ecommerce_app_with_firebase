import 'package:e_commerce_app_with_firebase/ui/bottom_nav_screen/cart_screen.dart';
import 'package:e_commerce_app_with_firebase/ui/bottom_nav_screen/favourite_screen.dart';
import 'package:e_commerce_app_with_firebase/ui/bottom_nav_screen/home_screen.dart';
import 'package:e_commerce_app_with_firebase/ui/bottom_nav_screen/profile_screen.dart';
import 'package:flutter/material.dart';

import '../constant/Colors/app_colors.dart';

class MainBottomNavScreen extends StatefulWidget {
  const MainBottomNavScreen({super.key});

  @override
  State<MainBottomNavScreen> createState() => _MainBottomNavScreenState();
}

class _MainBottomNavScreenState extends State<MainBottomNavScreen> {
   int _selectedIndex = 0;
  final List<Widget> _screen = const [
    HomeScreen(),
    FavouriteScreen(),
    CartScreen(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screen[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index){
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: AppColors.deep_orange,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: "Favourite",
            icon: Icon(Icons.favorite_outline),
          ),
          BottomNavigationBarItem(
            label: "Cart",
            icon: Icon(Icons.add_shopping_cart),
          ),
          BottomNavigationBarItem(
            label: "Profile",
            icon: Icon(Icons.person),
          ),
        ],

      ),
    );
  }
}
