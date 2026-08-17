import 'package:real_time/models/product_model.dart';
import 'package:real_time/models/order_model.dart';
import 'package:real_time/models/vendor_model.dart';
import 'package:real_time/services/firestore_service.dart';
import 'package:real_time/services/shared_preferences_service.dart';
import 'package:real_time/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ApiService with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final SharedPreferencesService _sharedPreferencesService = SharedPreferencesService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Get API keys from SharedPreferences
  Future<void> getApiKeys() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String apiKey = prefs.getString('apiKey')?? '';
    String apiSecret = prefs.getString('apiSecret')?? '';
    // Use API keys for API calls
  }

  // Save API keys to SharedPreferences
  Future<void> saveApiKeys(String apiKey, String apiSecret) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('apiKey', apiKey);
    prefs.setString('apiSecret', apiSecret);
    notifyListeners();
  }

  // Open dialog to save API keys
  void openApiKeysDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final _formKey = GlobalKey<FormState>();
        final _apiKeyController = TextEditingController();
        final _apiSecretController = TextEditingController();
        return AlertDialog(
          title: Text('Save API Keys'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _apiKeyController,
                  decoration: InputDecoration(labelText: 'API Key'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter API key';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _apiSecretController,
                  decoration: InputDecoration(labelText: 'API Secret'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter API secret';
                    }
                    return null;
                  },
                ),
              ],
            ),
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
                if (_formKey.currentState!.validate()) {
                  saveApiKeys(_apiKeyController.text, _apiSecretController.text);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Get products from Firestore
  Future<List<ProductModel>> getProducts() async {
    final QuerySnapshot snapshot = await _firestoreService.getProducts();
    return snapshot.docs.map((doc) => ProductModel.fromJson(doc.data())).toList();
  }

  // Get orders from Firestore
  Future<List<OrderModel>> getOrders() async {
    final QuerySnapshot snapshot = await _firestoreService.getOrders();
    return snapshot.docs.map((doc) => OrderModel.fromJson(doc.data())).toList();
  }

  // Get vendors from Firestore
  Future<List<VendorModel>> getVendors() async {
    final QuerySnapshot snapshot = await _firestoreService.getVendors();
    return snapshot.docs.map((doc) => VendorModel.fromJson(doc.data())).toList();
  }

  // Add product to Firestore
  Future<void> addProduct(ProductModel product) async {
    await _firestoreService.addProduct(product);
  }

  // Update product in Firestore
  Future<void> updateProduct(ProductModel product) async {
    await _firestoreService.updateProduct(product);
  }

  // Delete product from Firestore
  Future<void> deleteProduct(String productId) async {
    await _firestoreService.deleteProduct(productId);
  }

  // Update order status in Firestore
  Future<void> updateOrderStatus(String orderId, String status) async {
    await _firestoreService.updateOrderStatus(orderId, status);
  }
}