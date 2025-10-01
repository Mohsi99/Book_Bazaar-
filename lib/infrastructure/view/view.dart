import 'dart:ui';
import 'package:book_bazar/infrastructure/view/profile_views/profile_view.dart';
import 'package:flutter/material.dart';

import 'book_views/my_book_view.dart';
import 'home/home_view.dart';

class BottomNavigationBarView extends StatefulWidget {
  const BottomNavigationBarView({super.key});

  @override
  State<BottomNavigationBarView> createState() =>
      _BottomNavigationBarViewState();
}

class _BottomNavigationBarViewState extends State<BottomNavigationBarView> {
  int index = 0;

  void onChange(int value) {
    setState(() {
      index = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      HomeView(),
      YourBooksView(),
      ProfileView(),
    ];

    return Scaffold(
      body: Stack(
        children: [
          screens[index],
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                child: BottomNavigationBar(
                  elevation: 0,
                  selectedItemColor: const Color(0xFF6C63FF),
                  unselectedItemColor: Colors.grey.shade600,
                  backgroundColor: const Color(0xFFF7F7F9).withOpacity(0.9),
                  type: BottomNavigationBarType.fixed,
                  currentIndex: index,
                  onTap: onChange,
                  selectedLabelStyle: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF6C63FF),
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_rounded),
                      label: "Home",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.book_rounded),
                      label: "My Books",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person_rounded),
                      label: "Profile",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
