// lib/models/product.dart

import 'package:real_time/services/firestore_service.dart';

class Product {
  String? id;
  String? vendorId;
  String? name;
  String? description;
  double? price;
  int? quantity;
  String? category;
  String? imageUrl;

  Product({
    this.id,
    this.vendorId,
    this.name,
    this.description,
    this.price,
    this.quantity,
    this.category,
    this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      vendorId: json['vendorId'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      quantity: json['quantity'],
      category: json['category'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vendorId': vendorId,
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      'category': category,
      'imageUrl': imageUrl,
    };
  }

  static Future<List<Product>> getProducts() async {
    final products = await FirestoreService().getProducts();
    return products.map((json) => Product.fromJson(json)).toList();
  }

  static Future<Product> getProductById(String id) async {
    final product = await FirestoreService().getProductById(id);
    return Product.fromJson(product);
  }

  static Future<void> addProduct(Product product) async {
    await FirestoreService().addProduct(product.toJson());
  }

  static Future<void> updateProduct(Product product) async {
    await FirestoreService().updateProduct(product.id, product.toJson());
  }

  static Future<void> deleteProduct(String id) async {
    await FirestoreService().deleteProduct(id);
  }
}