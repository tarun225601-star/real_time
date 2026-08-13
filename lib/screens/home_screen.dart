import 'package:flutter/material.dart';
import 'package:marketplace_app/models/product.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketplace App'),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text('Product $index'),
              subtitle: const Text('Description'),
              leading: const CircleAvatar(
                backgroundImage: NetworkImage('https://via.placeholder.com/150'),
              ),
            ),
          );
        },
      ),
    );
  }
}