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
import '../../extensions/responsive_extensions.dart';
import '../../widgets/responsive/responsive_layout.dart';
// ignore: unused_import
import 'package:helloworld/utils/screen_size.dart';


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
    final screen = context.screen;
    
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6F9),
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: screen.responsive(mobile: 28, tablet: 30, desktop: 32),
              height: screen.responsive(mobile: 28, tablet: 30, desktop: 32),
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
            SizedBox(width: screen.responsive(mobile: 8, tablet: 10, desktop: 12)),
            Flexible(
              child: Text(
                'MENTIS - User Dashboard',
                style: TextStyle(
                  fontSize: screen.responsive(mobile: 16, tablet: 18, desktop: 20),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF0D9488),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _showProfileMenu,
            icon: Icon(
              Icons.person,
              size: screen.responsive(mobile: 22, tablet: 24, desktop: 24),
            ),
            tooltip: 'Profile',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: context.responsivePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Banner
            _buildWelcomeBanner(context),

            SizedBox(height: screen.responsive(mobile: 20, tablet: 22, desktop: 24)),

            // Stats Grid - Responsive
            _buildStatsGrid(context),

            SizedBox(height: screen.responsive(mobile: 24, tablet: 28, desktop: 32)),

            // Search and Filter Section
            _buildSearchFilterSection(context),

            SizedBox(height: screen.responsive(mobile: 20, tablet: 22, desktop: 24)),

            // Products List/Grid - Responsive
            _buildProductsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeBanner(BuildContext context) {
    final screen = context.screen;
    
    return ResponsiveCard(
      padding: EdgeInsets.all(
        screen.responsive(mobile: 20, tablet: 22, desktop: 24),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(
          screen.responsive(mobile: 20, tablet: 22, desktop: 24),
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0D9488), Color(0xFF1E293B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(
            screen.responsive(mobile: 12, tablet: 14, desktop: 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to MENTIS!',
              style: TextStyle(
                fontSize: screen.responsive(mobile: 20, tablet: 22, desktop: 24),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: screen.responsive(mobile: 6, tablet: 7, desktop: 8)),
            Text(
              'Discover amazing digital products and expand your knowledge',
              style: TextStyle(
                fontSize: screen.responsive(mobile: 14, tablet: 15, desktop: 16),
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    final screen = context.screen;
    final columns = screen.gridColumns;

    return GridView.count(
      crossAxisCount: columns,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: screen.responsive(mobile: 12, tablet: 14, desktop: 16),
      mainAxisSpacing: screen.responsive(mobile: 12, tablet: 14, desktop: 16),
      childAspectRatio: screen.responsive(
        mobile: 1.5,
        tablet: 1.7,
        desktop: 2.0,
      ),
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
  }

  Widget _buildSearchFilterSection(BuildContext context) {
    final screen = context.screen;
    
    return ResponsiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Explore Products',
            style: TextStyle(
              fontSize: screen.responsive(mobile: 18, tablet: 19, desktop: 20),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: screen.responsive(mobile: 12, tablet: 14, desktop: 16)),
          
          // Search bar
          TextField(
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
              _filterProducts();
            },
            style: TextStyle(
              fontSize: screen.responsive(mobile: 14, tablet: 15, desktop: 16),
            ),
            decoration: InputDecoration(
              hintText: 'Search products...',
              prefixIcon: Icon(
                Icons.search,
                size: screen.responsive(mobile: 20, tablet: 22, desktop: 24),
              ),
              border: const OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: screen.responsive(mobile: 12, tablet: 14, desktop: 16),
                vertical: screen.responsive(mobile: 12, tablet: 14, desktop: 16),
              ),
            ),
          ),
          
          SizedBox(height: screen.responsive(mobile: 12, tablet: 14, desktop: 16)),
          
          // Category filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', ...ProductService.getAllCategories()].map((category) {
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(
                      category,
                      style: TextStyle(
                        fontSize: screen.responsive(mobile: 12, tablet: 13, desktop: 14),
                      ),
                    ),
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
    );
  }

  Widget _buildProductsSection(BuildContext context) {
    final screen = context.screen;
    
    return ResponsiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Products (${_filteredProducts.length})',
                style: TextStyle(
                  fontSize: screen.responsive(mobile: 18, tablet: 19, desktop: 20),
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
                  child: Text(
                    'Clear Filters',
                    style: TextStyle(
                      fontSize: screen.responsive(mobile: 13, tablet: 14, desktop: 14),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: screen.responsive(mobile: 12, tablet: 14, desktop: 16)),
          
          // Responsive Layout: List for mobile, Grid for tablet/desktop
          if (_filteredProducts.isEmpty)
            _buildEmptyState(context)
          else
            ResponsiveLayout(
              mobile: _buildProductsList(context),
              tablet: _buildProductsGrid(context, columns: 2),
              desktop: _buildProductsGrid(context, columns: 3),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final screen = context.screen;
    
    return Center(
      child: Padding(
        padding: EdgeInsets.all(screen.responsive(mobile: 24, tablet: 28, desktop: 32)),
        child: Column(
          children: [
            Icon(
              Icons.search_off,
              size: screen.responsive(mobile: 56, tablet: 60, desktop: 64),
              color: Colors.grey,
            ),
            SizedBox(height: screen.responsive(mobile: 12, tablet: 14, desktop: 16)),
            Text(
              'No products found',
              style: TextStyle(
                fontSize: screen.responsive(mobile: 16, tablet: 17, desktop: 18),
                color: Colors.grey,
              ),
            ),
            Text(
              'Try adjusting your search or filters',
              style: TextStyle(
                fontSize: screen.responsive(mobile: 13, tablet: 13.5, desktop: 14),
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsList(BuildContext context) {
    return ListView.builder(
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
    );
  }

  Widget _buildProductsGrid(BuildContext context, {required int columns}) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        childAspectRatio: 0.75,
        crossAxisSpacing: context.responsive(mobile: 12, tablet: 14, desktop: 16),
        mainAxisSpacing: context.responsive(mobile: 12, tablet: 14, desktop: 16),
      ),
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        final product = _filteredProducts[index];
        return GridProductCard(
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
    );
  }

  void _showProfileMenu() {
    final screen = context.screen;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Profile Menu',
          style: TextStyle(
            fontSize: screen.responsive(mobile: 18, tablet: 19, desktop: 20),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                Icons.person,
                size: screen.responsive(mobile: 22, tablet: 23, desktop: 24),
              ),
              title: Text(
                'Profile',
                style: TextStyle(
                  fontSize: screen.responsive(mobile: 14, tablet: 15, desktop: 16),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                size: screen.responsive(mobile: 22, tablet: 23, desktop: 24),
              ),
              title: Text(
                'Settings',
                style: TextStyle(
                  fontSize: screen.responsive(mobile: 14, tablet: 15, desktop: 16),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.red,
                size: screen.responsive(mobile: 22, tablet: 23, desktop: 24),
              ),
              title: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: screen.responsive(mobile: 14, tablet: 15, desktop: 16),
                ),
              ),
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