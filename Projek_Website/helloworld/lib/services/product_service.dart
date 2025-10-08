// lib/services/product_service.dart
// ignore_for_file: prefer_final_fields

import '../models/product.dart';

class ProductService {
  // Sample data with OOP implementation
  static List<BaseProduct> _products = [
    DigitalProduct(
      id: '1',
      title: 'Flutter Complete Course',
      description: 'Learn Flutter development from scratch to advanced level.',
      price: 49.99,
      category: 'E-book',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      downloadUrl: 'https://example.com/flutter-course',
      downloadCount: 142,
      status: ProductStatus.active,
    ),
    DigitalProduct(
      id: '2',
      title: 'UI/UX Design Template Pack',
      description: 'Professional UI/UX templates for mobile applications.',
      price: 29.99,
      category: 'Template',
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      downloadUrl: 'https://example.com/ui-templates',
      downloadCount: 89,
      status: ProductStatus.active,
    ),
    PhysicalProduct(
      id: '3',
      title: 'Programming Books Bundle',
      description: 'Collection of programming books in physical format.',
      price: 99.99,
      category: 'Books',
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      stock: 25,
      weight: 2.5,
      status: ProductStatus.active,
    ),
    DigitalProduct(
      id: '4',
      title: 'Mobile App Icons Bundle',
      description: 'High-quality icons for mobile app development.',
      price: 19.99,
      category: 'Asset',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      downloadUrl: 'https://example.com/icons',
      downloadCount: 234,
      status: ProductStatus.active,
    ),
  ];

  // Polymorphism in action - all products return their display info differently
  static List<BaseProduct> getAllProducts() {
    return List.from(_products);
  }

  static BaseProduct? getProductById(String id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<BaseProduct> getProductsByCategory(String category) {
    return _products.where((product) => product.category == category).toList();
  }

  static List<String> getAllCategories() {
    return _products.map((product) => product.category).toSet().toList();
  }

  // Add new product
  static void addProduct(BaseProduct product) {
    _products.add(product);
  }

  // Update product
  static void updateProduct(BaseProduct updatedProduct) {
    final index = _products.indexWhere((product) => product.id == updatedProduct.id);
    if (index != -1) {
      _products[index] = updatedProduct;
    }
  }

  // Delete product
  static void deleteProduct(String id) {
    _products.removeWhere((product) => product.id == id);
  }
}