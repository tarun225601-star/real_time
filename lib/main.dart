
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/home_screen.dart';
import 'package:instagram_clone/screens/feed_screen.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/utils/constants.dart';
import 'package:instagram_clone/utils/styles.dart';
import 'package:instagram_clone/services/api_service.dart';
import 'package:instagram_clone/services/storage_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constants.appTitle,
      theme: Styles.theme,
      home: HomeScreen(),
    );
  }
}
