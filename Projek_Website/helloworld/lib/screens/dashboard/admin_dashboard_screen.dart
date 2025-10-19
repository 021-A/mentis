// lib/screens/dashboard/admin_dashboard_screen.dart
// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:helloworld/screens/dashboard/admin_profile_screen.dart' show AdminProfileScreen;
import 'package:helloworld/screens/dashboard/settings_screen.dart' show SettingsScreen;
import 'package:helloworld/screens/products/add_product_screen.dart';
import 'package:helloworld/screens/orders/orders_screen.dart';
import 'package:helloworld/screens/products/products_screen.dart';
import 'package:helloworld/screens/users/users_screen.dart';
import 'package:helloworld/screens/analytics/analytics_screen.dart';

import '../../services/auth_service.dart';
import '../../services/product_service.dart';
import '../../models/product.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/product_card.dart';
import '../../widgets/responsive_card.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final AuthService _authService = AuthService();
  List<BaseProduct> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    setState(() {
      _products = ProductService.getAllProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6F9),
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/Logo.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.admin_panel_settings,
                      size: 20,
                      color: Colors.white,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Text('MENTIS - Admin Dashboard'),
          ],
        ),
        backgroundColor: const Color(0xFF0D9488),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddProductScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
            tooltip: 'Add Product',
          ),
          IconButton(
            onPressed: _showAdminMenu,
            icon: const Icon(Icons.admin_panel_settings),
            tooltip: 'Admin Menu',
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 1024;

          return SingleChildScrollView(
            padding: EdgeInsets.all(isDesktop ? 24 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner
                ResponsiveCard(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0D9488), Color(0xFF1E293B)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Admin Dashboard',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Manage your digital store and monitor performance',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Stats
                GridView.count(
                  crossAxisCount: constraints.maxWidth > 800 ? 4 : 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.5,
                  children: [
                    StatCard(
                      title: 'Total Sales',
                      value: '\$2,450',
                      icon: Icons.attach_money,
                      color: const Color(0xFF10B981),
                    ),
                    StatCard(
                      title: 'Orders',
                      value: '142',
                      icon: Icons.shopping_bag,
                      color: const Color(0xFF3B82F6),
                    ),
                    StatCard(
                      title: 'Products',
                      value: '${_products.length}',
                      icon: Icons.inventory,
                      color: const Color(0xFF8B5CF6),
                    ),
                    StatCard(
                      title: 'Users',
                      value: '89',
                      icon: Icons.people,
                      color: const Color(0xFFEF4444),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Quick Actions
                ResponsiveCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Quick Actions',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GridView.count(
                        crossAxisCount: constraints.maxWidth > 600 ? 2 : 1,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 3,
                        children: [
                          _buildActionCard(
                            'Add Product',
                            'Create new digital product',
                            Icons.add_box,
                            const Color(0xFF0D9488),
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AddProductScreen()),
                              );
                            },
                          ),
                          _buildActionCard(
                            'View Orders',
                            'Manage customer orders',
                            Icons.list_alt,
                            const Color(0xFF1E293B),
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const OrdersScreen()),
                              );
                            },
                          ),
                          _buildActionCard(
                            'Manage Users',
                            'View and manage users',
                            Icons.people,
                            const Color(0xFF7C3AED),
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const UsersScreen()),
                              );
                            },
                          ),
                          _buildActionCard(
                            'Analytics',
                            'View detailed reports',
                            Icons.analytics,
                            const Color(0xFFF97316),
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AnalyticsScreen()),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Recent Products
                ResponsiveCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Recent Products',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ProductsScreen()),
                              );
                            },
                            child: const Text('View All'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _products.take(4).length,
                        itemBuilder: (context, index) {
                          final product = _products[index];
                          return ProductCard(
                            product: product,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/product-detail',
                                arguments: product,
                              );
                            },
                            onEdit: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AddProductScreen(product: product),
                                ),
                              );
                            },
                            onDelete: () {
                              _showDeleteConfirmation(product);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionCard(
      String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BaseProduct product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete "${product.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ProductService.deleteProduct(product.id);
              _loadProducts();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Product deleted successfully!'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAdminMenu() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Admin Menu'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Admin Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminProfileScreen(),
                ),
              );
            },
          ),
          const Divider(),
            ListTile(
              leading: const Icon(Icons.inventory),
              title: const Text('Manage Products'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProductsScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_bag),
              title: const Text('Manage Orders'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const OrdersScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Manage Users'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UsersScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.analytics),
              title: const Text('Analytics'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AnalyticsScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsScreen()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () async {
                Navigator.pop(context);
                await _authService.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}
