import 'package:flutter/material.dart';
import 'package:marketapp/screens/main_screen.dart';
import 'package:marketapp/screens/product_group_screen.dart';
import 'package:marketapp/screens/product_screen.dart';
import 'package:marketapp/screens/sales_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const MainScreen(),
    );
  }
}


