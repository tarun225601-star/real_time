import 'package:real_time/models/product.dart';
import 'package:real_time/models/order.dart';
import 'package:real_time/services/firestore_service.dart';

class Vendor {
  String id;
  String name;
  String email;
  String phone;
  String address;
  List<Product> products;
  List<Order> orders;

  Vendor({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    this.products = const [],
    this.orders = const [],
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      products: (json['products'] as List)
         .map((product) => Product.fromJson(product))
         .toList(),
      orders: (json['orders'] as List)
         .map((order) => Order.fromJson(order))
         .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'products': products.map((product) => product.toJson()).toList(),
      'orders': orders.map((order) => order.toJson()).toList(),
    };
  }

  static Future<Vendor> getVendor(String id) async {
    final firestoreService = FirestoreService();
    final vendorData = await firestoreService.getVendor(id);
    return Vendor.fromJson(vendorData);
  }

  static Future<void> updateVendor(Vendor vendor) async {
    final firestoreService = FirestoreService();
    await firestoreService.updateVendor(vendor);
  }

  static Future<void> addProduct(String vendorId, Product product) async {
    final firestoreService = FirestoreService();
    await firestoreService.addProduct(vendorId, product);
  }

  static Future<void> updateProduct(String vendorId, Product product) async {
    final firestoreService = FirestoreService();
    await firestoreService.updateProduct(vendorId, product);
  }

  static Future<void> deleteProduct(String vendorId, String productId) async {
    final firestoreService = FirestoreService();
    await firestoreService.deleteProduct(vendorId, productId);
  }

  static Future<void> updateOrderStatus(String vendorId, String orderId, String status) async {
    final firestoreService = FirestoreService();
    await firestoreService.updateOrderStatus(vendorId, orderId, status);
  }
}