import 'package:real_time/models/vendor_model.dart';
import 'package:real_time/models/product_model.dart';
import 'package:real_time/models/order_model.dart';
import 'package:real_time/services/firebase_service.dart';
import 'package:real_time/services/shared_preferences_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class StateManagementService with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  final SharedPreferencesService _sharedPreferencesService = SharedPreferencesService();

  List<VendorModel> _vendors = [];
  List<ProductModel> _products = [];
  List<OrderModel> _orders = [];

  List<VendorModel> get vendors => _vendors;
  List<ProductModel> get products => _products;
  List<OrderModel> get orders => _orders;

  void loadVendors() async {
    final vendorsData = await _firebaseService.getVendors();
    _vendors = vendorsData.map((vendor) => VendorModel.fromJson(vendor)).toList();
    notifyListeners();
  }

  void loadProducts() async {
    final productsData = await _firebaseService.getProducts();
    _products = productsData.map((product) => ProductModel.fromJson(product)).toList();
    notifyListeners();
  }

  void loadOrders() async {
    final ordersData = await _firebaseService.getOrders();
    _orders = ordersData.map((order) => OrderModel.fromJson(order)).toList();
    notifyListeners();
  }

  void addProduct(ProductModel product) async {
    await _firebaseService.addProduct(product);
    _products.add(product);
    notifyListeners();
  }

  void updateProduct(ProductModel product) async {
    await _firebaseService.updateProduct(product);
    final index = _products.indexWhere((element) => element.id == product.id);
    _products[index] = product;
    notifyListeners();
  }

  void deleteProduct(String productId) async {
    await _firebaseService.deleteProduct(productId);
    _products.removeWhere((element) => element.id == productId);
    notifyListeners();
  }

  void addOrder(OrderModel order) async {
    await _firebaseService.addOrder(order);
    _orders.add(order);
    notifyListeners();
  }

  void updateOrder(OrderModel order) async {
    await _firebaseService.updateOrder(order);
    final index = _orders.indexWhere((element) => element.id == order.id);
    _orders[index] = order;
    notifyListeners();
  }

  void saveApiKeys(String apiKey, String apiSecret) async {
    await _sharedPreferencesService.saveApiKeys(apiKey, apiSecret);
  }

  void openSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final apiKeyController = TextEditingController();
        final apiSecretController = TextEditingController();
        return AlertDialog(
          title: Text('Save API Keys'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: apiKeyController,
                decoration: InputDecoration(labelText: 'API Key'),
              ),
              TextField(
                controller: apiSecretController,
                decoration: InputDecoration(labelText: 'API Secret'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                saveApiKeys(apiKeyController.text, apiSecretController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}