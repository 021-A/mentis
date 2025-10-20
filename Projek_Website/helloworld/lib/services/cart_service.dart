// lib/services/cart_service.dart

import 'dart:convert';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart_item.dart';
import '../models/order.dart';
import '../models/product.dart';

/// Service untuk manage Cart & Orders
/// Catatan penting:
/// - Model Order pada project Anda menyimpan **satu** BaseProduct per Order.
///   Oleh karena itu, saat checkout kita buat satu Order per CartItem (sederhana).
/// - createOrder(...) akan mengembalikan Order pertama yang dibuat (atau null jika gagal).
class CartService {
  static const String _cartKey = 'shopping_cart';
  static const String _ordersKey = 'order_history';

  // In-memory cart items
  static final List<CartItem> _cartItems = [];

  // In-memory orders
  static final List<Order> _orders = [];

  /// Load cart dari SharedPreferences
  static Future<void> loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = prefs.getString(_cartKey);

      if (cartJson != null) {
        final List<dynamic> decoded = json.decode(cartJson);
        _cartItems.clear();
        _cartItems.addAll(
          decoded.map((item) => CartItem.fromJson(item)).toList(),
        );
      }
      debugPrint('✅ Cart loaded: ${_cartItems.length} items');
    } catch (e) {
      debugPrint('❌ Error loading cart: $e');
    }
  }

  /// Save cart ke SharedPreferences
  static Future<void> _saveCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = json.encode(
        _cartItems.map((item) => item.toJson()).toList(),
      );
      await prefs.setString(_cartKey, cartJson);
      debugPrint('✅ Cart saved: ${_cartItems.length} items');
    } catch (e) {
      debugPrint('❌ Error saving cart: $e');
    }
  }

  /// Load orders dari SharedPreferences
  static Future<void> loadOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ordersJson = prefs.getString(_ordersKey);

      if (ordersJson != null) {
        final List<dynamic> decoded = json.decode(ordersJson);
        _orders.clear();
        _orders.addAll(
          decoded.map((order) => Order.fromJson(order)).toList(),
        );
      }
      debugPrint('✅ Orders loaded: ${_orders.length} orders');
    } catch (e) {
      debugPrint('❌ Error loading orders: $e');
    }
  }

  /// Save orders ke SharedPreferences
  static Future<void> _saveOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ordersJson = json.encode(
        _orders.map((order) => order.toJson()).toList(),
      );
      await prefs.setString(_ordersKey, ordersJson);
      debugPrint('✅ Orders saved: ${_orders.length} orders');
    } catch (e) {
      debugPrint('❌ Error saving orders: $e');
    }
  }

  // ==================== CART OPERATIONS ====================

  /// Get all cart items
  static List<CartItem> getCartItems() {
    return List.unmodifiable(_cartItems);
  }

  /// Get cart item count (total quantity)
  static int getCartItemCount() {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  /// Get cart total amount
  static double getCartTotal() {
    return _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  /// Add product to cart
  static Future<bool> addToCart(BaseProduct product, {int quantity = 1}) async {
    try {
      // Cek apakah product sudah ada di cart (by product id)
      final existingIndex = _cartItems.indexWhere(
        (item) => item.product.id == product.id,
      );

      if (existingIndex != -1) {
        // Product sudah ada, tambah quantity
        _cartItems[existingIndex].quantity += quantity;
      } else {
        // Product baru, tambahkan ke cart
        final cartItem = CartItem(
          id: 'cart_${DateTime.now().millisecondsSinceEpoch}',
          product: product,
          quantity: quantity,
        );
        _cartItems.add(cartItem);
      }

      await _saveCart();
      return true;
    } catch (e) {
      debugPrint('❌ Error adding to cart: $e');
      return false;
    }
  }

  /// Remove item from cart
  static Future<bool> removeFromCart(String cartItemId) async {
    try {
      _cartItems.removeWhere((item) => item.id == cartItemId);
      await _saveCart();
      return true;
    } catch (e) {
      debugPrint('❌ Error removing from cart: $e');
      return false;
    }
  }

  /// Update cart item quantity
  static Future<bool> updateCartItemQuantity(
    String cartItemId,
    int newQuantity,
  ) async {
    try {
      if (newQuantity <= 0) {
        return await removeFromCart(cartItemId);
      }

      final index = _cartItems.indexWhere((item) => item.id == cartItemId);
      if (index != -1) {
        _cartItems[index].quantity = newQuantity;
        await _saveCart();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('❌ Error updating cart quantity: $e');
      return false;
    }
  }

  /// Clear cart
  static Future<void> clearCart() async {
    _cartItems.clear();
    await _saveCart();
  }

  // ==================== ORDER OPERATIONS ====================

  /// Create order(s) from current cart.
  ///
  /// NOTE: Your `Order` model stores a single `BaseProduct` per Order.
  /// Therefore this function will create one Order per CartItem and insert
  /// them into the order history. It returns the first created Order (or null).
  ///
  /// Parameters:
  /// - userId: required
  /// - customerName/customerEmail: optional (can be empty string)
  /// - licenseKeyGenerator: optional callback if you want to generate license for digital products
  static Future<Order?> createOrder(
    String userId, {
    String? customerName,
    String? customerEmail,
    String? notes,
    String Function(BaseProduct product)? licenseKeyGenerator,
  }) async {
    try {
      if (_cartItems.isEmpty) {
        debugPrint('❌ Cart is empty');
        return null;
      }

      final createdOrders = <Order>[];

      for (final cartItem in List<CartItem>.from(_cartItems)) {
        final product = cartItem.product;
        final amount = cartItem.totalPrice;

        // Generate licenseKey if digital product and generator provided
        final licenseKey = (product is DigitalProduct && licenseKeyGenerator != null)
            ? licenseKeyGenerator(product)
            : null;

        final order = Order(
          id: 'order_${DateTime.now().millisecondsSinceEpoch}_${product.id}',
          userId: userId,
          customerName: customerName ?? '',
          customerEmail: customerEmail ?? '',
          product: product,
          amount: amount,
          status: OrderStatus.processing,
          createdAt: DateTime.now(),
          licenseKey: licenseKey,
        );

        // Add to order history (newest first)
        _orders.insert(0, order);
        createdOrders.add(order);
      }

      await _saveOrders();

      // Clear cart after creating orders
      await clearCart();

      debugPrint('✅ Orders created: ${createdOrders.length}');
      return createdOrders.isNotEmpty ? createdOrders.first : null;
    } catch (e) {
      debugPrint('❌ Error creating order: $e');
      return null;
    }
  }

  /// Get all orders
  static List<Order> getOrders() {
    return List.unmodifiable(_orders);
  }

  /// Get orders by user
  static List<Order> getOrdersByUser(String userId) {
    return _orders.where((order) => order.userId == userId).toList();
  }

  /// Get order by ID
  static Order? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }

  /// Update order status
  static Future<bool> updateOrderStatus(
    String orderId,
    OrderStatus newStatus,
  ) async {
    try {
      final index = _orders.indexWhere((order) => order.id == orderId);
      if (index != -1) {
        // Use Order.updateStatus to keep immutability behavior from model
        _orders[index] = _orders[index].updateStatus(newStatus);
        await _saveOrders();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('❌ Error updating order status: $e');
      return false;
    }
  }

  /// Cancel order (maps to refunded status)
  static Future<bool> cancelOrder(String orderId) async {
    return await updateOrderStatus(orderId, OrderStatus.refunded);
  }

  // ==================== HELPER METHODS ====================

  /// Check if product is in cart
  static bool isInCart(String productId) {
    return _cartItems.any((item) => item.product.id == productId);
  }

  /// Get cart item by product ID
  static CartItem? getCartItemByProductId(String productId) {
    try {
      return _cartItems.firstWhere(
        (item) => item.product.id == productId,
      );
    } catch (e) {
      return null;
    }
  }
}
