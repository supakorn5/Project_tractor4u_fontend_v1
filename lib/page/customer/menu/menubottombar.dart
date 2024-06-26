import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:tractor4your/page/customer/menu/mainMenu.dart';
import 'package:tractor4your/page/customer/menu/paymoney.dart';

class MenuBottombar extends StatefulWidget {
  const MenuBottombar({super.key});

  @override
  State<MenuBottombar> createState() => _MenuBottombarState();
}

class _MenuBottombarState extends State<MenuBottombar> {
  int _pageIndex = 0;

  final List _pages = [const MainMenu(), const PayMoney()];

  Widget _buildIconWithText(IconData icon, String text) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon),
        const SizedBox(height: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 15, fontFamily: "Itim"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _pages[_pageIndex],
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.white,
          buttonBackgroundColor: Colors.white,
          color: const Color.fromARGB(255, 246, 177, 122),
          animationDuration: const Duration(milliseconds: 300),
          height: 50,
          items: [
            _buildIconWithText(Icons.home, 'หน้าหลัก'),
            _buildIconWithText(Icons.monetization_on, 'ชำระเงิน'),
          ],
          onTap: (index) {
            setState(() {
              _pageIndex = index;
            });
          },
        ),
      ),
    );
  }
}
