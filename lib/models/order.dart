import 'package:real_time/models/vendor.dart';
import 'package:real_time/models/product.dart';
import 'package:real_time/models/user.dart';

class Order {
  String? id;
  String? userId;
  String? vendorId;
  List<Product>? products;
  double? totalCost;
  String? status;
  String? paymentMethod;
  String? address;
  String? createdAt;

  Order({
    this.id,
    this.userId,
    this.vendorId,
    this.products,
    this.totalCost,
    this.status,
    this.paymentMethod,
    this.address,
    this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['userId'],
      vendorId: json['vendorId'],
      products: json['products'] != null
          ? (json['products'] as List)
              .map((product) => Product.fromJson(product))
              .toList()
          : [],
      totalCost: json['totalCost'],
      status: json['status'],
      paymentMethod: json['paymentMethod'],
      address: json['address'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'vendorId': vendorId,
      'products': products != null
          ? products!.map((product) => product.toJson()).toList()
          : [],
      'totalCost': totalCost,
      'status': status,
      'paymentMethod': paymentMethod,
      'address': address,
      'createdAt': createdAt,
    };
  }
}

class OrderStatus {
  static const String pending = 'pending';
  static const String packed = 'packed';
  static const String outForDelivery = 'out_for_delivery';
  static const String delivered = 'delivered';
  static const String cancelled = 'cancelled';
}