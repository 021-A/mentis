// lib/screens/dashboard/user_dashboard_screen.dart
// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:helloworld/screens/dashboard/profile_screen_user.dart' show ProfileScreen;
import 'package:helloworld/screens/dashboard/settings_screen.dart' show SettingsScreen;
import '../../services/auth_service.dart';
import '../../services/product_service.dart';
import '../../models/product.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/product_card.dart';
import '../../widgets/responsive_card.dart';

class UserDashboardScreen extends StatefulWidget {
  const UserDashboardScreen({super.key});

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  final AuthService _authService = AuthService();
  List<BaseProduct> _products = [];
  List<BaseProduct> _filteredProducts = [];
  String _searchQuery = '';
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    setState(() {
      _products = ProductService.getAllProducts();
      _filteredProducts = _products;
    });
  }

  void _filterProducts() {
    setState(() {
      _filteredProducts = _products.where((product) {
        final matchesSearch = product.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                             product.description.toLowerCase().contains(_searchQuery.toLowerCase());
        final matchesCategory = _selectedCategory == 'All' || product.category == _selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();
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
                      Icons.school,
                      size: 20,
                      color: Colors.white,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Text('MENTIS - User Dashboard'),
          ],
        ),
        backgroundColor: const Color(0xFF0D9488),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _showProfileMenu,
            icon: const Icon(Icons.person),
            tooltip: 'Profile',
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 1024;
          final isTablet = constraints.maxWidth > 768 && constraints.maxWidth <= 1024;
          
          return SingleChildScrollView(
            padding: EdgeInsets.all(isDesktop ? 24 : (isTablet ? 20 : 16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Banner
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
                          'Welcome to MENTIS!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Discover amazing digital products and expand your knowledge',
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

                // Stats Row
                LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount = constraints.maxWidth > 800 ? 4 : 2;
                    return GridView.count(
                      crossAxisCount: crossAxisCount,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.5,
                      children: [
                        StatCard(
                          title: 'Available Products',
                          value: '${_products.length}',
                          icon: Icons.inventory,
                          color: const Color(0xFF10B981),
                        ),
                        StatCard(
                          title: 'Categories',
                          value: '${ProductService.getAllCategories().length}',
                          icon: Icons.category,
                          color: const Color(0xFF3B82F6),
                        ),
                        StatCard(
                          title: 'Digital Items',
                          value: '${_products.whereType<DigitalProduct>().length}',
                          icon: Icons.download,
                          color: const Color(0xFF8B5CF6),
                        ),
                        StatCard(
                          title: 'Physical Items',
                          value: '${_products.whereType<PhysicalProduct>().length}',
                          icon: Icons.inventory_2,
                          color: const Color(0xFFEF4444),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 32),

                // Search and Filter Section
                ResponsiveCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Explore Products',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Search bar
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                          _filterProducts();
                        },
                        decoration: const InputDecoration(
                          hintText: 'Search products...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Category filter
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: ['All', ...ProductService.getAllCategories()].map((category) {
                            final isSelected = _selectedCategory == category;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(category),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedCategory = category;
                                  });
                                  _filterProducts();
                                },
                                selectedColor: const Color(0xFF0D9488).withOpacity(0.2),
                                checkmarkColor: const Color(0xFF0D9488),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Products List
                ResponsiveCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Products (${_filteredProducts.length})',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (_filteredProducts.isEmpty && _searchQuery.isNotEmpty)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _searchQuery = '';
                                  _selectedCategory = 'All';
                                  _filteredProducts = _products;
                                });
                              },
                              child: const Text('Clear Filters'),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      if (_filteredProducts.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No products found',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  'Try adjusting your search or filters',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = _filteredProducts[index];
                            return ProductCard(
                              product: product,
                              showActions: false,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/product-detail',
                                  arguments: product,
                                );
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

  void _showProfileMenu() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Profile Menu'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
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
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              },
            ),
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
