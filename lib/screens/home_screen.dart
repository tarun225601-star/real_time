import 'package:flutter/material.dart';
import 'package:real_time/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketplace App'),
      ),
      body: Center(
        child: Text(
          'Welcome to Marketplace App',
          style: TextStyle(
            fontSize: 24,
            color: AppTheme.lightTheme.primaryColor,
          ),
        ),
      ),
    );
  }
}