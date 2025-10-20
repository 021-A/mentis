// lib/screens/cart/cart_screen.dart
import 'package:flutter/material.dart';
import '../../models/cart_item.dart';
import '../../services/cart_service.dart';
import '../../services/auth_service.dart';
import '../../utils/formatters.dart';
import '../../utils/image_helper.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> _cartItems = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    setState(() => _isLoading = true);
    await CartService.loadCart();
    if (!mounted) return;
    setState(() {
      _cartItems = CartService.getCartItems();
      _isLoading = false;
    });
  }

  Future<void> _removeItem(String cartItemId) async {
    final success = await CartService.removeFromCart(cartItemId);
    if (success && mounted) {
      setState(() => _cartItems = CartService.getCartItems());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item removed from cart'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Future<void> _updateQuantity(String cartItemId, int newQuantity) async {
    final success = await CartService.updateCartItemQuantity(
      cartItemId,
      newQuantity,
    );
    if (success && mounted) {
      setState(() => _cartItems = CartService.getCartItems());
    }
  }

  Future<void> _checkout() async {
    if (_cartItems.isEmpty) return;

    setState(() => _isLoading = true);

    // Get current user
    final authService = AuthService();
    final user = await authService.getCurrentUser();

    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please login to checkout'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => _isLoading = false);
      }
      return;
    }

    // Create order
    final order = await CartService.createOrder(user.email);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (order != null && mounted) {
      // Extract readable status text from enum
      final statusText = order.status.toString().split('.').last;

      // Show success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 32),
              SizedBox(width: 12),
              Text('Order Created!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Order ID: ${order.id}'),
              SizedBox(height: 8),
              Text('Total: ${AppFormatters.formatCurrency(order.amount)}'),
              SizedBox(height: 8),
              Text('Status: $statusText'),
              SizedBox(height: 16),
              Text(
                'Your order has been created successfully. You can view it in Order History.',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to previous screen
              },
              child: Text('OK'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pushNamed(context, '/order-history');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0D9488),
              ),
              child: Text('View Orders'),
            ),
          ],
        ),
      );

      // Refresh cart
      setState(() => _cartItems = CartService.getCartItems());
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = CartService.getCartTotal();

    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart (${_cartItems.length})'),
        backgroundColor: Color(0xFF0D9488),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _cartItems.isEmpty
              ? _buildEmptyCart()
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: _cartItems.length,
                        itemBuilder: (context, index) {
                          return _buildCartItemCard(_cartItems[index]);
                        },
                      ),
                    ),
                    _buildCheckoutSection(total),
                  ],
                ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 120,
            color: Colors.grey[300],
          ),
          SizedBox(height: 24),
          Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Add some products to get started!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.shopping_bag),
            label: Text('Browse Products'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF0D9488),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItemCard(CartItem item) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 80,
                height: 80,
                color: Color(0xFF0D9488).withValues(alpha: 0.1),
                child: item.product.imageUrl != null
                    ? ImageHelper.getImageWidget(
                        item.product.imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      )
                    : Icon(
                        Icons.inventory,
                        color: Color(0xFF0D9488),
                        size: 40,
                      ),
              ),
            ),
            SizedBox(width: 12),

            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    item.product.category,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    AppFormatters.formatCurrency(item.product.price),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D9488),
                    ),
                  ),
                ],
              ),
            ),

            // Quantity Controls
            Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (item.quantity > 1) {
                          _updateQuantity(item.id, item.quantity - 1);
                        }
                      },
                      icon: Icon(Icons.remove_circle_outline),
                      color: Color(0xFF0D9488),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                    SizedBox(width: 12),
                    Text(
                      '${item.quantity}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 12),
                    IconButton(
                      onPressed: () {
                        _updateQuantity(item.id, item.quantity + 1);
                      },
                      icon: Icon(Icons.add_circle_outline),
                      color: Color(0xFF0D9488),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                IconButton(
                  onPressed: () => _removeItem(item.id),
                  icon: Icon(Icons.delete_outline),
                  color: Colors.red,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutSection(double total) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total (${CartService.getCartItemCount()} items):',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  AppFormatters.formatCurrency(total),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D9488),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _checkout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0D9488),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : Text(
                        'Checkout',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
