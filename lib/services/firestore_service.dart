import 'package:real_time/models/product_model.dart';
import 'package:real_time/models/order_model.dart';
import 'package:real_time/models/vendor_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create a new product
  Future<void> createProduct(ProductModel product) async {
    await _firestore.collection('products').doc(product.id).set({
      'id': product.id,
      'name': product.name,
      'description': product.description,
      'price': product.price,
      'stock': product.stock,
      'vendorId': product.vendorId,
      'imageUrl': product.imageUrl,
    });
  }

  // Get all products
  Stream<List<ProductModel>> getProducts() {
    return _firestore.collection('products').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProductModel(
          id: doc['id'],
          name: doc['name'],
          description: doc['description'],
          price: doc['price'],
          stock: doc['stock'],
          vendorId: doc['vendorId'],
          imageUrl: doc['imageUrl'],
        );
      }).toList();
    });
  }

  // Get products by vendor
  Stream<List<ProductModel>> getProductsByVendor(String vendorId) {
    return _firestore
       .collection('products')
       .where('vendorId', isEqualTo: vendorId)
       .snapshots()
       .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProductModel(
          id: doc['id'],
          name: doc['name'],
          description: doc['description'],
          price: doc['price'],
          stock: doc['stock'],
          vendorId: doc['vendorId'],
          imageUrl: doc['imageUrl'],
        );
      }).toList();
    });
  }

  // Update product
  Future<void> updateProduct(ProductModel product) async {
    await _firestore.collection('products').doc(product.id).update({
      'name': product.name,
      'description': product.description,
      'price': product.price,
      'stock': product.stock,
      'imageUrl': product.imageUrl,
    });
  }

  // Delete product
  Future<void> deleteProduct(String productId) async {
    await _firestore.collection('products').doc(productId).delete();
  }

  // Create a new order
  Future<void> createOrder(OrderModel order) async {
    await _firestore.collection('orders').doc(order.id).set({
      'id': order.id,
      'customerId': order.customerId,
      'vendorId': order.vendorId,
      'products': order.products,
      'status': order.status,
    });
  }

  // Get all orders
  Stream<List<OrderModel>> getOrders() {
    return _firestore.collection('orders').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return OrderModel(
          id: doc['id'],
          customerId: doc['customerId'],
          vendorId: doc['vendorId'],
          products: doc['products'],
          status: doc['status'],
        );
      }).toList();
    });
  }

  // Get orders by vendor
  Stream<List<OrderModel>> getOrdersByVendor(String vendorId) {
    return _firestore
       .collection('orders')
       .where('vendorId', isEqualTo: vendorId)
       .snapshots()
       .map((snapshot) {
      return snapshot.docs.map((doc) {
        return OrderModel(
          id: doc['id'],
          customerId: doc['customerId'],
          vendorId: doc['vendorId'],
          products: doc['products'],
          status: doc['status'],
        );
      }).toList();
    });
  }

  // Update order status
  Future<void> updateOrderStatus(String orderId, String status) async {
    await _firestore.collection('orders').doc(orderId).update({
      'status': status,
    });
  }

  // Create a new vendor
  Future<void> createVendor(VendorModel vendor) async {
    await _firestore.collection('vendors').doc(vendor.id).set({
      'id': vendor.id,
      'name': vendor.name,
      'email': vendor.email,
      'phone': vendor.phone,
    });
  }

  // Get all vendors
  Stream<List<VendorModel>> getVendors() {
    return _firestore.collection('vendors').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return VendorModel(
          id: doc['id'],
          name: doc['name'],
          email: doc['email'],
          phone: doc['phone'],
        );
      }).toList();
    });
  }

  // Get vendor by id
  Stream<VendorModel> getVendorById(String vendorId) {
    return _firestore.collection('vendors').doc(vendorId).snapshots().map((doc) {
      return VendorModel(
        id: doc['id'],
        name: doc['name'],
        email: doc['email'],
        phone: doc['phone'],
      );
    });
  }

  // Save API keys using SharedPreferences
  Future<void> saveApiKeys(String apiKey, String apiSecret) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('apiKey', apiKey);
    await prefs.setString('apiSecret', apiSecret);
  }

  // Get API keys using SharedPreferences
  Future<void> getApiKeys() async {
    final prefs = await SharedPreferences.getInstance();
    final apiKey = prefs.getString('apiKey');
    final apiSecret = prefs.getString('apiSecret');
    // Use the API keys as needed
  }

  // Show settings dialog to save API keys
  void showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
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
}