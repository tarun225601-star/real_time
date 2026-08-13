import 'package:flutter/material.dart';
import 'package:marketplace_app/models/product.dart';

class HomeScreenController with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => _products;

  void loadProducts() {
    // Load products from API or database
    _products = [
      Product(
        id: '1',
        name: 'Product 1',
        description: 'Description 1',
        price: 10.99,
        imageUrl: 'https://via.placeholder.com/150',
      ),
      Product(
        id: '2',
        name: 'Product 2',
        description: 'Description 2',
        price: 9.99,
        imageUrl: 'https://via.placeholder.com/150',
      ),
    ];
    notifyListeners();
  }
}