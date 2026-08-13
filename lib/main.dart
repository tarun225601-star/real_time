import 'package:flutter/material.dart';

void main() {
    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
    const MyApp({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return const MaterialApp(
            title: 'app',
            home: MyHomePage(),
        );
    }
}

class MyHomePage extends StatelessWidget {
    const MyHomePage({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: const Text('app'),
            ),
            body: Center(
                child: const Text('app'), // Added const keyword here
            ),
        );
    }
}