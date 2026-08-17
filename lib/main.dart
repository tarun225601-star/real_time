import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ==========================================
// 1. MODELS
// ==========================================

class VendorModel {
  final String id;
  final String name;

  VendorModel({required this.id, required this.name});

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final String vendorId;
  final String imageUrl;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.vendorId,
    required this.imageUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      stock: json['stock'] as int? ?? 0,
      vendorId: json['vendorId'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'stock': stock,
        'vendorId': vendorId,
        'imageUrl': imageUrl,
      };
}

class OrderModel {
  final String id;
  final String customerId;
  final String vendorId;
  final List<dynamic> products;
  final String status;

  OrderModel({
    required this.id,
    required this.customerId,
    required this.vendorId,
    required this.products,
    required this.status,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      customerId: json['customerId'] ?? '',
      vendorId: json['vendorId'] ?? '',
      products: json['products'] ?? [],
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'customerId': customerId,
        'vendorId': vendorId,
        'products': products,
        'status': status,
      };
}

// ==========================================
// 2. SERVICES
// ==========================================

class SharedPreferencesService {
  static Future<void> saveApiKey(String apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('api_key', apiKey);
  }

  static Future<void> saveApiSecret(String apiSecret) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('api_secret', apiSecret);
  }

  static Future<void> setTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark', isDark);
  }

  static Future<bool?> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_dark');
  }

  Future<void> saveApiKeys(String apiKey, String apiSecret) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('api_key', apiKey);
    await prefs.setString('api_secret', apiSecret);
  }

  Future<void> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
}

class FirestoreService with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getVendors() async {
    final snapshot = await _firestore.collection('vendors').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<List<Map<String, dynamic>>> getProducts() async {
    final snapshot = await _firestore.collection('products').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<List<Map<String, dynamic>>> getOrders() async {
    final snapshot = await _firestore.collection('orders').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<void> addProduct(ProductModel product) async {
    await _firestore.collection('products').doc(product.id).set(product.toJson());
  }

  Future<void> updateProduct(ProductModel product) async {
    await _firestore.collection('products').doc(product.id).update(product.toJson());
  }

  Future<void> deleteProduct(String productId) async {
    await _firestore.collection('products').doc(productId).delete();
  }

  Future<void> addOrder(OrderModel order) async {
    await _firestore.collection('orders').doc(order.id).set(order.toJson());
  }

  Future<void> updateOrder(OrderModel order) async {
    await _firestore.collection('orders').doc(order.id).update(order.toJson());
  }
}

class StateManagementService with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final SharedPreferencesService _sharedPreferencesService = SharedPreferencesService();

  List<VendorModel> _vendors = [];
  List<ProductModel> _products = [];
  List<OrderModel> _orders = [];

  List<VendorModel> get vendors => _vendors;
  List<ProductModel> get products => _products;
  List<OrderModel> get orders => _orders;

  void loadVendors() async {
    final vendorsData = await _firestoreService.getVendors();
    _vendors = vendorsData.map((vendor) => VendorModel.fromJson(vendor)).toList();
    notifyListeners();
  }

  void loadProducts() async {
    final productsData = await _firestoreService.getProducts();
    _products = productsData.map((product) => ProductModel.fromJson(product)).toList();
    notifyListeners();
  }

  void loadOrders() async {
    final ordersData = await _firestoreService.getOrders();
    _orders = ordersData.map((order) => OrderModel.fromJson(order)).toList();
    notifyListeners();
  }

  void addProduct(ProductModel product) async {
    await _firestoreService.addProduct(product);
    _products.add(product);
    notifyListeners();
  }

  void updateProduct(ProductModel product) async {
    await _firestoreService.updateProduct(product);
    final index = _products.indexWhere((element) => element.id == product.id);
    if (index != -1) _products[index] = product;
    notifyListeners();
  }

  void deleteProduct(String productId) async {
    await _firestoreService.deleteProduct(productId);
    _products.removeWhere((element) => element.id == productId);
    notifyListeners();
  }

  void addOrder(OrderModel order) async {
    await _firestoreService.addOrder(order);
    _orders.add(order);
    notifyListeners();
  }

  void updateOrder(OrderModel order) async {
    await _firestoreService.updateOrder(order);
    final index = _orders.indexWhere((element) => element.id == order.id);
    if (index != -1) _orders[index] = order;
    notifyListeners();
  }

  void saveApiKeys(String apiKey, String apiSecret) async {
    await _sharedPreferencesService.saveApiKeys(apiKey, apiSecret);
  }
}

// ==========================================
// 3. SCREENS
// ==========================================

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/vendor-admin');
          },
          child: Text('Login / Continue'),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Screen')),
      body: Center(child: Text('Welcome to Quick Commerce Home!')),
    );
  }
}

class VendorAdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Vendor Admin Dashboard')),
      body: Center(child: Text('Manage your products and orders here.')),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Center(child: Text('Settings Options')),
    );
  }
}

// ==========================================
// 4. MAIN ENTRY POINT
// ==========================================

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FirestoreService()),
        ChangeNotifierProvider(create: (_) => StateManagementService()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quick Commerce',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return VendorAdminScreen();
          } else {
            return LoginScreen();
          }
        },
      ),
      routes: {
        '/home': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/vendor-admin': (context) => VendorAdminScreen(),
        '/settings': (context) => SettingsScreen(),
      },
    );
  }
}
