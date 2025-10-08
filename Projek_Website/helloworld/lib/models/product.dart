// lib/models/product.dart
abstract class BaseProduct {
  final String id;
  final String title;
  final String description;
  final double price;
  final String category;
  final DateTime createdAt;

  BaseProduct({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.createdAt,
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
      'downloadUrl': downloadUrl,
      'downloadCount': downloadCount,
      'status': _status.toString().split('.').last,
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
      downloadUrl: json['downloadUrl'] ?? '',
      downloadCount: json['downloadCount'] ?? 0,
      status: ProductStatus.values.firstWhere(
        (e) => e.toString() == 'ProductStatus.${json['status']}',
        orElse: () => ProductStatus.active,
      ),
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
      'stock': stock,
      'weight': weight,
      'status': _status.toString().split('.').last,
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
      stock: json['stock'] ?? 0,
      weight: (json['weight'] ?? 0).toDouble(),
      status: ProductStatus.values.firstWhere(
        (e) => e.toString() == 'ProductStatus.${json['status']}',
        orElse: () => ProductStatus.active,
      ),
    );
  }
}

enum ProductStatus { active, draft, inactive }
