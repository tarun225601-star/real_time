import 'package:flutter/material.dart';
import 'package:real_time/calculator_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Real Time App',
      home: CalculatorPage(),
    );
  }
}
