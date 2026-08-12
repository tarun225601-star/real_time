import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    // Add a delay to prevent rate limit exceeded error
    Future.delayed(const Duration(minutes: 8), () {
      // Your API call or code that was causing the rate limit error
      _makeApiCall();
    });
  }

  void _makeApiCall() async {
    try {
      final response = await http.get(Uri.parse('https://your-api-url.com'));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        // Process your JSON data
      } else {
        // Handle error
      }
    } catch (e) {
      // Handle exception
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Real Time'),
      ),
      body: const Center(
        child: Text('Real Time App'),
      ),
    );
  }
}