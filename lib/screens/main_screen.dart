import 'package:flutter/material.dart';
import 'package:marketapp/screens/product_group_screen.dart';
import 'package:marketapp/screens/product_screen.dart';
import 'package:marketapp/screens/sales_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  List<Widget> _pages = [
     ProductGroupScreen(),
    ProductScreen(),
    SalesScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.group),label: "Ürün Grupları"),
          BottomNavigationBarItem(icon: Icon(Icons.group), label:  "Ürünler"),
          BottomNavigationBarItem(icon: Icon(Icons.group),label: "Satış Ekranı"),
        ],
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
      ) ,
    );
  }

  void _onItemTapped(int value) {
    setState(() {
      _selectedIndex = value;
    });
  }
}
