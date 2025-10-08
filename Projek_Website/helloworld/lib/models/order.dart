// lib/models/order.dart

import '../models/product.dart';

class Order {
  final String id;
  final String userId;
  final String customerName;
  final String customerEmail;
  final BaseProduct product;
  final double amount;
  final OrderStatus _status;
  final DateTime createdAt;
  final String? licenseKey;

  Order({
    required this.id,
    required this.userId,
    required this.customerName,
    required this.customerEmail,
    required this.product,
    required this.amount,
    OrderStatus? status,
    required this.createdAt,
    this.licenseKey,
  }) : _status = status ?? OrderStatus.processing;

  // Encapsulation - getter for status
  OrderStatus get status => _status;

  // Setter for status with validation
  Order updateStatus(OrderStatus newStatus) {
    return Order(
      id: id,
      userId: userId,
      customerName: customerName,
      customerEmail: customerEmail,
      product: product,
      amount: amount,
      status: newStatus,
      createdAt: createdAt,
      licenseKey: licenseKey,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'product': product.toJson(),
      'amount': amount,
      'status': _status.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'licenseKey': licenseKey,
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    BaseProduct product;
    if (json['product']['type'] == 'digital') {
      product = DigitalProduct.fromJson(json['product']);
    } else {
      product = PhysicalProduct.fromJson(json['product']);
    }

    return Order(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      customerName: json['customerName'] ?? '',
      customerEmail: json['customerEmail'] ?? '',
      product: product,
      amount: (json['amount'] ?? 0).toDouble(),
      status: OrderStatus.values.firstWhere(
        (e) => e.toString() == 'OrderStatus.${json['status']}',
        orElse: () => OrderStatus.processing,
      ),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      licenseKey: json['licenseKey'],
    );
  }
}

enum OrderStatus { processing, completed, failed, refunded }
