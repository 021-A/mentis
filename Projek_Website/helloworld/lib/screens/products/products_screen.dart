// lib/screens/products/products_screen.dart
import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../services/product_service.dart';
import '../../utils/formatters.dart';
import 'add_product_screen.dart';
import '../detail/product_detail_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<BaseProduct> _products = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedCategory = 'All';
  List<String> _categories = ['All'];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  /// ✨ NEW: Load products from ProductService
  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    
    await ProductService.loadProducts();
    _products = ProductService.getAllProducts();
    _categories = ['All', ...ProductService.getAllCategories()];
    
    setState(() => _isLoading = false);
  }

  /// ✨ ENHANCED: Filter products by search & category
  List<BaseProduct> get _filteredProducts {
    var filtered = _products;

    // Filter by category
    if (_selectedCategory != 'All') {
      filtered = filtered.where((p) => p.category == _selectedCategory).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((p) {
        return p.title.toLowerCase().contains(query) ||
            p.description.toLowerCase().contains(query);
      }).toList();
    }

    return filtered;
  }

  /// ✨ ENHANCED: Add or edit product with ProductService
  Future<void> _navigateToAddOrEdit([BaseProduct? product]) async {
    final result = await Navigator.push<BaseProduct?>(
      context,
      MaterialPageRoute(builder: (_) => AddProductScreen(product: product)),
    );

    if (result != null) {
      if (product == null) {
        // Add new product
        await ProductService.addProduct(result);
      } else {
        // Update existing product
        await ProductService.updateProduct(result);
      }

      await _loadProducts(); // Reload from service

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(product == null
                ? "${result.title} berhasil ditambahkan."
                : "${result.title} berhasil diperbarui."),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  /// ✨ NEW: Delete product
  Future<void> _deleteProduct(BaseProduct product) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Produk'),
        content: Text('Yakin ingin menghapus "${product.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ProductService.deleteProduct(product.id);
      await _loadProducts();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${product.title} berhasil dihapus.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _filteredProducts;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        actions: [
          // Search button
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(),
          ),
          // Add button
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: "Tambah Produk",
            onPressed: () => _navigateToAddOrEdit(),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Category filter chips
                if (_categories.length > 1)
                  Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        final isSelected = category == _selectedCategory;
                        
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(category),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() => _selectedCategory = category);
                            },
                            selectedColor: const Color(0xFF0D9488),
                            checkmarkColor: Colors.white,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                // Products list
                Expanded(
                  child: filteredProducts.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.inventory_2_outlined,
                                size: 80,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _searchQuery.isEmpty
                                    ? "Belum ada produk.\nTambahkan produk baru."
                                    : "Tidak ada produk yang cocok.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredProducts.length,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemBuilder: (context, index) {
                            final product = filteredProducts[index];
                            return _buildProductCard(product);
                          },
                        ),
                ),
              ],
            ),
    );
  }

  /// ✨ ENHANCED: Product card with image support & better UI
  Widget _buildProductCard(BaseProduct product) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
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
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image/icon
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: product.imageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          product.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(
                            product is DigitalProduct
                                ? Icons.cloud_download
                                : Icons.inventory,
                            color: Colors.grey[400],
                            size: 32,
                          ),
                        ),
                      )
                    : Icon(
                        product is DigitalProduct
                            ? Icons.cloud_download
                            : Icons.inventory,
                        color: Colors.grey[400],
                        size: 32,
                      ),
              ),
              const SizedBox(width: 12),

              // Product info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title & Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            product.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          AppFormatters.formatCurrency(product.price),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0D9488),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Description
                    Text(
                      product.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Additional info & Actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Info chips
                        Expanded(
                          child: Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: [
                              _buildInfoChip(
                                product.category,
                                Icons.category_outlined,
                              ),
                              if (product is DigitalProduct)
                                _buildInfoChip(
                                  '${product.downloadCount} downloads',
                                  Icons.download_outlined,
                                )
                              else if (product is PhysicalProduct)
                                _buildInfoChip(
                                  'Stock: ${product.stock}',
                                  Icons.inventory_2_outlined,
                                ),
                            ],
                          ),
                        ),

                        // Action buttons
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, size: 20),
                              color: Colors.orange,
                              onPressed: () => _navigateToAddOrEdit(product),
                              visualDensity: VisualDensity.compact,
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, size: 20),
                              color: Colors.red,
                              onPressed: () => _deleteProduct(product),
                              visualDensity: VisualDensity.compact,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ✨ NEW: Info chip widget
  Widget _buildInfoChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  /// ✨ NEW: Search dialog
  Future<void> _showSearchDialog() async {
    final controller = TextEditingController(text: _searchQuery);
    
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Products'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter product name...',
            prefixIcon: Icon(Icons.search),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => _searchQuery = '');
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
          TextButton(
            onPressed: () {
              setState(() => _searchQuery = controller.text);
              Navigator.pop(context);
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }
}