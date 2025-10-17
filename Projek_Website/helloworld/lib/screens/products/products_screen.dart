// lib/screens/products/products_screen.dart
// ignore_for_file: deprecated_member_use, unnecessary_cast

import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../widgets/product_card.dart';
import '../../extensions/responsive_extensions.dart';
import '../../utils/screen_size.dart';
import '../../constants/spacing.dart';
import 'add_product_screen.dart';
import '../detail/product_detail_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isGridView = true;

  // Dummy data
  final List<BaseProduct> _products = [
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
    DigitalProduct(
      id: '5',
      title: 'React Native Course',
      description: 'Master React Native development with real projects.',
      price: 59.99,
      category: 'E-book',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      downloadUrl: 'https://example.com/react-course',
      downloadCount: 67,
      status: ProductStatus.active,
    ),
    PhysicalProduct(
      id: '6',
      title: 'Coding Keyboard',
      description: 'Mechanical keyboard designed for programmers.',
      price: 149.99,
      category: 'Hardware',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      stock: 15,
      weight: 1.2,
      status: ProductStatus.active,
    ),
  ];

  List<String> get _categories {
    final cats = _products.map((p) => p.category).toSet().toList();
    return ['All', ...cats];
  }

  List<BaseProduct> get _filteredProducts {
    return _products.where((product) {
      final matchesCategory =
          _selectedCategory == 'All' || product.category == _selectedCategory;
      final matchesSearch = product.title
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          product.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  Future<void> _navigateToAddOrEdit([BaseProduct? product]) async {
    final BaseProduct? result = await Navigator.push<BaseProduct?>(
      context,
      MaterialPageRoute(builder: (_) => AddProductScreen(product: product)),
    );

    if (result != null) {
      setState(() {
        if (product == null) {
          _products.add(result);
        } else {
          final index = _products.indexWhere((p) => p.id == product.id);
          if (index != -1) {
            _products[index] = result;
          }
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(product == null
                ? "${result.title} berhasil ditambahkan."
                : "${result.title} berhasil diperbarui."),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _deleteProduct(BaseProduct product) {
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
              setState(() {
                _products.removeWhere((p) => p.id == product.id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${product.title} deleted'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSize.of(context);
    final isDesktop = screenSize.isDesktop;
    final isTablet = screenSize.isTablet;
    final isMobile = screenSize.isMobile;
    final filteredProducts = _filteredProducts;

    return Scaffold(
      body: Column(
        children: [
          // Header Section
          _buildHeader(isDesktop, isTablet, isMobile),

          // Category Filter
          _buildCategoryFilter(),

          // Products Grid/List
          Expanded(
            child: filteredProducts.isEmpty
                ? _buildEmptyState(isMobile)
                : _buildProductsView(filteredProducts, isDesktop, isTablet, isMobile),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddOrEdit(),
        icon: const Icon(Icons.add),
        label: Text(isDesktop ? 'Add Product' : 'Add'),
      ),
    );
  }

  Widget _buildHeader(bool isDesktop, bool isTablet, bool isMobile) {
    final inputDecoration = InputDecoration(
      hintText: 'Search products...',
      prefixIcon: const Icon(Icons.search),
      suffixIcon: _searchQuery.isNotEmpty
          ? IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => setState(() => _searchQuery = ''),
            )
          : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd ?? 12.0),
      ),
      filled: true,
      fillColor: Colors.grey[100],
    );

    // Get responsive values (type already known by analyzer)
    final padding = context.responsivePadding as EdgeInsets;
    final spacing = context.responsiveSpacing as double;
    final smallSpacing = context.responsiveSmallSpacing as double;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Products',
                      style: TextStyle(
                        fontSize: isMobile ? 20.0 : 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: smallSpacing),
                    Text(
                      '${_products.length} total products',
                      style: TextStyle(
                        fontSize: isMobile ? 12.0 : 14.0,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              if (isDesktop || isTablet)
                IconButton(
                  icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
                  onPressed: () => setState(() => _isGridView = !_isGridView),
                  tooltip: _isGridView ? 'List View' : 'Grid View',
                ),
            ],
          ),
          SizedBox(height: spacing),
          // Search Bar
          TextField(
            onChanged: (value) => setState(() => _searchQuery = value),
            decoration: inputDecoration,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    // Get responsive values (type already known by analyzer)
    final padding = context.responsivePadding as EdgeInsets;
    final spacing = context.responsiveSpacing as double;
    final smallSpacing = context.responsiveSmallSpacing as double;
    
    final horizontalPadding = padding.horizontal / 2;
    final verticalPadding = spacing;
    final itemSpacing = smallSpacing;

    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => SizedBox(width: itemSpacing),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;

          return FilterChip(
            label: Text(category),
            selected: isSelected,
            onSelected: (selected) {
              setState(() => _selectedCategory = category);
            },
            backgroundColor: Colors.grey[200],
            selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
            checkmarkColor: Theme.of(context).primaryColor,
            labelStyle: TextStyle(
              color: isSelected ? Theme.of(context).primaryColor : Colors.grey[700],
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductsView(
    List<BaseProduct> products,
    bool isDesktop,
    bool isTablet,
    bool isMobile,
  ) {
    if (!_isGridView && (isDesktop || isTablet)) {
      return _buildListView(products);
    }

    final crossAxisCount = isDesktop ? 4 : (isTablet ? 3 : 2);
    final childAspectRatio = isDesktop ? 0.75 : (isTablet ? 0.7 : 0.65);
    
    // Get responsive values (type already known by analyzer)
    final padding = context.responsivePadding as EdgeInsets;
    final spacing = context.responsiveSpacing as double;

    return GridView.builder(
      padding: padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return GridProductCard(
          product: product,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailScreen(
                  product: product,
                  productId: product.id,
                ),
              ),
            );
          },
          onEdit: () => _navigateToAddOrEdit(product),
          onDelete: () => _deleteProduct(product),
        );
      },
    );
  }

  Widget _buildListView(List<BaseProduct> products) {
    // Get responsive values (type already known by analyzer)
    final padding = context.responsivePadding as EdgeInsets;
    final spacing = context.responsiveSpacing as double;

    return ListView.separated(
      padding: padding,
      itemCount: products.length,
      separatorBuilder: (_, __) => SizedBox(height: spacing),
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          product: product,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailScreen(
                  product: product,
                  productId: product.id,
                ),
              ),
            );
          },
          onEdit: () => _navigateToAddOrEdit(product),
          onDelete: () => _deleteProduct(product),
        );
      },
    );
  }

  Widget _buildEmptyState(bool isMobile) {
    // Get responsive values (type already known by analyzer)
    final spacing = context.responsiveSpacing as double;
    final smallSpacing = context.responsiveSmallSpacing as double;
    final largeSpacing = context.responsiveLargeSpacing as double;
    final iconSize = context.responsiveIconSize(80) as double;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _searchQuery.isNotEmpty ? Icons.search_off : Icons.inventory_2_outlined,
            size: iconSize,
            color: Colors.grey[400],
          ),
          SizedBox(height: spacing),
          Text(
            _searchQuery.isNotEmpty ? 'No products found' : 'No products yet',
            style: TextStyle(
              fontSize: isMobile ? 16.0 : 18.0,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: smallSpacing),
          Text(
            _searchQuery.isNotEmpty 
                ? 'Try different search terms' 
                : 'Add your first product to get started',
            style: TextStyle(
              fontSize: isMobile ? 12.0 : 14.0,
              color: Colors.grey[500],
            ),
          ),
          if (_searchQuery.isEmpty) ...[
            SizedBox(height: largeSpacing),
            ElevatedButton.icon(
              onPressed: () => _navigateToAddOrEdit(),
              icon: const Icon(Icons.add),
              label: const Text('Add Product'),
            ),
          ],
        ],
      ),
    );
  }
}