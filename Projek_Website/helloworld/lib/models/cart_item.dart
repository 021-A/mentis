// lib/models/cart_item.dart

import 'product.dart';

/// Model untuk item di shopping cart
class CartItem {
  final String id; // Unique ID untuk cart item
  final BaseProduct product;
  int quantity;
  final DateTime addedAt;

  CartItem({
    required this.id,
    required this.product,
    this.quantity = 1,
    DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();

  /// Total harga untuk item ini (price × quantity)
  double get totalPrice => product.price * quantity;

  /// Convert to JSON untuk save ke SharedPreferences
  /// Note: include 'productType' & 'productCreatedAt' agar restorasi lebih akurat.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': product.id,
      'productTitle': product.title,
      'productPrice': product.price,
      'productCategory': product.category,
      'productDescription': product.description,
      'productImageUrl': product.imageUrl,
      'productType': product is DigitalProduct ? 'digital' : 'physical',
      // Include product createdAt for accurate reconstruction
      'productCreatedAt': product.createdAt.toIso8601String(),
      // Jika product adalah DigitalProduct, sertakan fields spesifiknya
      if (product is DigitalProduct) ...{
        'downloadUrl': (product as DigitalProduct).downloadUrl,
        'downloadCount': (product as DigitalProduct).downloadCount,
      },
      // If physical, include stock/weight if present (optional)
      if (product is PhysicalProduct) ...{
        'weight': (product as PhysicalProduct).weight,
        'stock': (product as PhysicalProduct).stock,
      },
      'quantity': quantity,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  /// Create from JSON
  factory CartItem.fromJson(Map<String, dynamic> json) {
    // Safely read primitive fields with fallback
    final id = json['id']?.toString() ?? '';
    final quantity = (json['quantity'] is int)
        ? json['quantity'] as int
        : int.tryParse(json['quantity']?.toString() ?? '') ?? 1;

    final productId = json['productId']?.toString() ?? '';
    final productTitle = json['productTitle']?.toString() ?? '';
    final productPrice =
        (json['productPrice'] is num) ? (json['productPrice'] as num).toDouble() : double.tryParse(json['productPrice']?.toString() ?? '') ?? 0.0;
    final productCategory = json['productCategory']?.toString() ?? '';
    final productDescription = json['productDescription']?.toString() ?? '';
    final productImageUrl = json['productImageUrl']?.toString() ?? '';
    final productType = json['productType']?.toString();

    // Try to parse createdAt for the product, fallback to now
    final productCreatedAt = DateTime.tryParse(json['productCreatedAt']?.toString() ?? '') ?? DateTime.now();

    BaseProduct product;

    // Reconstruct product based on explicit productType if present,
    // otherwise infer from presence of downloadUrl.
    if (productType == 'digital' || json.containsKey('downloadUrl')) {
      product = DigitalProduct(
        id: productId,
        title: productTitle,
        price: productPrice,
        category: productCategory,
        description: productDescription,
        imageUrl: productImageUrl,
        downloadUrl: json['downloadUrl']?.toString() ?? '',
        downloadCount: (json['downloadCount'] is int)
            ? json['downloadCount'] as int
            : int.tryParse(json['downloadCount']?.toString() ?? '') ?? 0,
        createdAt: productCreatedAt,
      );
    } else {
      // Fallback to PhysicalProduct
      product = PhysicalProduct(
        id: productId,
        title: productTitle,
        price: productPrice,
        category: productCategory,
        description: productDescription,
        imageUrl: productImageUrl,
        weight: (json['weight'] is num) ? (json['weight'] as num).toDouble() : double.tryParse(json['weight']?.toString() ?? '') ?? 0.0,
        stock: (json['stock'] is int) ? json['stock'] as int : int.tryParse(json['stock']?.toString() ?? '') ?? 0,
        createdAt: productCreatedAt,
      );
    }

    final addedAt = DateTime.tryParse(json['addedAt']?.toString() ?? '') ?? DateTime.now();

    return CartItem(
      id: id,
      product: product,
      quantity: quantity,
      addedAt: addedAt,
    );
  }

  /// Copy with new values
  CartItem copyWith({
    String? id,
    BaseProduct? product,
    int? quantity,
    DateTime? addedAt,
  }) {
    return CartItem(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      addedAt: addedAt ?? this.addedAt,
    );
  }
}
