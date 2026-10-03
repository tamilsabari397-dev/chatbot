import 'package:flutter/material.dart';

import 'screens/home_screen.dart';


void main() {
  runApp(
    const ExpenseApp(),
  );
}


class ExpenseApp extends StatelessWidget {
  const ExpenseApp({super.key});


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: "Daily Expenses",

      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
      ),

      home: const HomeScreen(),
    );
  }
}