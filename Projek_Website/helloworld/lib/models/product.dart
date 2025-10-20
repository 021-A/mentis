// ✨ NEW: Add import for Color
import 'package:flutter/material.dart' show Color;
// lib/models/product.dart
abstract class BaseProduct {
  final String id;
  final String title;
  final String description;
  final double price;
  final String category;
  final DateTime createdAt;
  final String? imageUrl; // ✨ NEW: Image support

  BaseProduct({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.createdAt,
    this.imageUrl, // ✨ NEW: Optional image URL
  });

  // ignore: strict_top_level_inference
  get status => null;

  // Abstract methods for polymorphism
  String getDisplayInfo();
  Map<String, dynamic> toJson();
}

class DigitalProduct extends BaseProduct {
  final String downloadUrl;
  final int downloadCount;
  final ProductStatus _status;

  DigitalProduct({
    required super.id,
    required super.title,
    required super.description,
    required super.price,
    required super.category,
    required super.createdAt,
    super.imageUrl, // ✨ NEW: Pass imageUrl to parent
    required this.downloadUrl,
    required this.downloadCount,
    ProductStatus? status,
  }) : _status = status ?? ProductStatus.active;

  // Encapsulation - getter for status
  @override
  ProductStatus get status => _status;

  // Override polymorphic method
  @override
  String getDisplayInfo() {
    return '$title - Digital Product (\$$price)';
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'imageUrl': imageUrl, // ✨ NEW: Include imageUrl in JSON
      'downloadUrl': downloadUrl,
      'downloadCount': downloadCount,
      'status': _status.name, // ✨ FIXED: Use .name directly (safe)
      'type': 'digital',
    };
  }

  factory DigitalProduct.fromJson(Map<String, dynamic> json) {
    return DigitalProduct(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      category: json['category'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      imageUrl: json['imageUrl'], // ✨ NEW: Load imageUrl from JSON
      downloadUrl: json['downloadUrl'] ?? '',
      downloadCount: json['downloadCount'] ?? 0,
      status: _parseProductStatus(json['status']), // ✨ FIXED: Use helper
    );
  }

  // ✨ NEW: Copy with method for easy updates
  DigitalProduct copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    String? category,
    DateTime? createdAt,
    String? imageUrl,
    String? downloadUrl,
    int? downloadCount,
    ProductStatus? status,
  }) {
    return DigitalProduct(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      imageUrl: imageUrl ?? this.imageUrl,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      downloadCount: downloadCount ?? this.downloadCount,
      status: status ?? this.status,
    );
  }
}

class PhysicalProduct extends BaseProduct {
  final int stock;
  final double weight;
  final ProductStatus _status;

  PhysicalProduct({
    required super.id,
    required super.title,
    required super.description,
    required super.price,
    required super.category,
    required super.createdAt,
    super.imageUrl, // ✨ NEW: Pass imageUrl to parent
    required this.stock,
    required this.weight,
    ProductStatus? status,
  }) : _status = status ?? ProductStatus.active;

  // Encapsulation - getter for status
  @override
  ProductStatus get status => _status;

  // Override polymorphic method
  @override
  String getDisplayInfo() {
    return '$title - Physical Product (\$$price) - Stock: $stock';
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'imageUrl': imageUrl, // ✨ NEW: Include imageUrl in JSON
      'stock': stock,
      'weight': weight,
      'status': _status.name, // ✨ FIXED: Use .name directly (safe)
      'type': 'physical',
    };
  }

  factory PhysicalProduct.fromJson(Map<String, dynamic> json) {
    return PhysicalProduct(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      category: json['category'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      imageUrl: json['imageUrl'], // ✨ NEW: Load imageUrl from JSON
      stock: json['stock'] ?? 0,
      weight: (json['weight'] ?? 0).toDouble(),
      status: _parseProductStatus(json['status']), // ✨ FIXED: Use helper
    );
  }

  // ✨ NEW: Copy with method for easy updates
  PhysicalProduct copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    String? category,
    DateTime? createdAt,
    String? imageUrl,
    int? stock,
    double? weight,
    ProductStatus? status,
  }) {
    return PhysicalProduct(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      imageUrl: imageUrl ?? this.imageUrl,
      stock: stock ?? this.stock,
      weight: weight ?? this.weight,
      status: status ?? this.status,
    );
  }
}

// ✨ ENHANCED: Enum with helper methods
enum ProductStatus { 
  active, 
  draft, 
  inactive;
  
  // ✨ NEW: Helper to get display name
  String get displayName {
    switch (this) {
      case ProductStatus.active:
        return 'Active';
      case ProductStatus.draft:
        return 'Draft';
      case ProductStatus.inactive:
        return 'Inactive';
    }
  }
  
  // ✨ NEW: Helper to get color
  // ignore: recursive_getters
  get color {
    switch (this) {
      case ProductStatus.active:
        return const Color(0xFF10B981); // Green
      case ProductStatus.draft:
        return const Color(0xFFF59E0B); // Orange
      case ProductStatus.inactive:
        return const Color(0xFFEF4444); // Red
    }
  }
}

// ✨ NEW: Helper function to parse ProductStatus safely
ProductStatus _parseProductStatus(dynamic status) {
  if (status == null) return ProductStatus.active;
  
  if (status is ProductStatus) return status;
  
  final statusStr = status.toString().toLowerCase();
  switch (statusStr) {
    case 'active':
      return ProductStatus.active;
    case 'draft':
      return ProductStatus.draft;
    case 'inactive':
      return ProductStatus.inactive;
    default:
      return ProductStatus.active;
  }
}