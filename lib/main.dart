import 'package:flutter/material.dart';
import 'package:marketplace_app/app_theme.dart';
import 'package:marketplace_app/screens/home_screen.dart';

void main() {
  runApp(const MarketplaceApp());
}

class MarketplaceApp extends StatelessWidget {
  const MarketplaceApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marketplace App',
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}