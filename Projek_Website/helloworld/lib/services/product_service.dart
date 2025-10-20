// lib/services/product_service.dart
// ignore_for_file: prefer_final_fields

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/product.dart';
import 'package:flutter/foundation.dart';

class ProductService {
  // ✨ NEW: SharedPreferences key
  static const String _productsKey = 'products_list';

  // Sample data with OOP implementation
  static List<BaseProduct> _products = [
    DigitalProduct(
      id: '1',
      title: 'Flutter Complete Course',
      description: 'Learn Flutter development from scratch to advanced level.',
      price: 49.99,
      category: 'E-book',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      imageUrl: null, // ✨ NEW: Image support (null = use default icon)
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
      imageUrl: null, // ✨ NEW: Image support
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
      imageUrl: null, // ✨ NEW: Image support
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
      imageUrl: null, // ✨ NEW: Image support
      downloadUrl: 'https://example.com/icons',
      downloadCount: 234,
      status: ProductStatus.active,
    ),
  ];

  // ✨ NEW: Load products from SharedPreferences
  static Future<void> loadProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final productsJson = prefs.getStringList(_productsKey);
      
      if (productsJson != null && productsJson.isNotEmpty) {
        _products = productsJson.map((jsonStr) {
          final json = jsonDecode(jsonStr);
          final type = json['type'] as String;
          
          if (type == 'digital') {
            return DigitalProduct.fromJson(json);
          } else {
            return PhysicalProduct.fromJson(json);
          }
        }).toList();
      }
    } catch (e) {
      // If error, use default products
      debugPrint('Error loading products: $e');
    }
  }

  // ✨ NEW: Save products to SharedPreferences
  static Future<void> saveProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final productsJson = _products.map((product) {
        return jsonEncode(product.toJson());
      }).toList();
      
      await prefs.setStringList(_productsKey, productsJson);
    } catch (e) {
      debugPrint('Error saving products: $e');
    }
  }

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

  // ✨ ENHANCED: Add new product with auto-save
  static Future<void> addProduct(BaseProduct product) async {
    _products.add(product);
    await saveProducts();
  }

  // ✨ ENHANCED: Update product with auto-save
  static Future<void> updateProduct(BaseProduct updatedProduct) async {
    final index = _products.indexWhere((product) => product.id == updatedProduct.id);
    if (index != -1) {
      _products[index] = updatedProduct;
      await saveProducts();
    }
  }

  // ✨ ENHANCED: Delete product with auto-save
  static Future<void> deleteProduct(String id) async {
    _products.removeWhere((product) => product.id == id);
    await saveProducts();
  }

  // ✨ NEW: Search products
  static List<BaseProduct> searchProducts(String query) {
    final lowerQuery = query.toLowerCase();
    return _products.where((product) {
      return product.title.toLowerCase().contains(lowerQuery) ||
          product.description.toLowerCase().contains(lowerQuery) ||
          product.category.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // ✨ NEW: Get products by status
  static List<BaseProduct> getProductsByStatus(ProductStatus status) {
    return _products.where((product) => product.status == status).toList();
  }

  // ✨ NEW: Get total product count
  static int getProductCount() {
    return _products.length;
  }

  // ✨ NEW: Clear all products (for testing)
  static Future<void> clearAllProducts() async {
    _products.clear();
    await saveProducts();
  }
}