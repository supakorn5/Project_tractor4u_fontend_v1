import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:tractor4your/page/customer/menu/Customer_mainMenu.dart';
import 'package:tractor4your/page/customer/menu/paymoney.dart';

class MenuBottombar extends StatefulWidget {
  final int? id;
  const MenuBottombar({super.key, this.id});

  @override
  State<MenuBottombar> createState() => _MenuBottombarState();
}

class _MenuBottombarState extends State<MenuBottombar> {
  int? Id;
  int _pageIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    Id = widget.id;
    _pages = <Widget>[
      MainMenu(id: Id!),
      const PayMoney()
    ]; // Explicitly specify the type as List<Widget>
  }

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
