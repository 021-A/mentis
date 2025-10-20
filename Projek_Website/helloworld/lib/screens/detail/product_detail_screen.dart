// lib/screens/detail/product_detail_screen.dart
import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../services/product_service.dart';
import '../../services/cart_service.dart';
import '../../utils/formatters.dart';
import '../../utils/image_helper.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;
  final BaseProduct? product; // optional product passed from caller

  const ProductDetailScreen({
    super.key,
    required this.productId,
    this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _isAdding = false;

  @override
  Widget build(BuildContext context) {
    // Use provided product if available; otherwise fetch by id
    final product = widget.product ?? ProductService.getProductById(widget.productId);

    if (product == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Product Detail"),
          backgroundColor: const Color(0xFF0D9488),
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Text(
            "Product not found.",
            style: TextStyle(fontSize: 18, color: Colors.redAccent),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        backgroundColor: const Color(0xFF0D9488),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image Section (large)
                if (product.imageUrl != null && product.imageUrl!.isNotEmpty)
                  Column(
                    children: [
                      Hero(
                        tag: 'product_${product.id}',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: double.infinity,
                            height: 300,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0D9488).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ImageHelper.getImageWidget(
                              product.imageUrl,
                              width: double.infinity,
                              height: 300,
                              fit: BoxFit.cover,
                              errorWidget: Container(
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.inventory,
                                  size: 80,
                                  color: Color(0xFF0D9488),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),

                // Product Title
                Text(
                  product.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                // Category & Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Chip(
                      label: Text(product.category),
                      backgroundColor: Colors.blue.shade50,
                    ),
                    // Safely get status display name
                    Chip(
                      label: Text(
                        _getStatusDisplayName(product.status),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: _getStatusColor(product.status),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Description
                Text(
                  product.description,
                  style: const TextStyle(fontSize: 16, height: 1.4),
                ),

                const SizedBox(height: 20),

                // Price - Format dengan Rupiah
                Row(
                  children: [
                    const Icon(Icons.price_change, color: Colors.orange),
                    const SizedBox(width: 8),
                    Text(
                      AppFormatters.formatCurrency(product.price),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Conditional Info based on product type (Polymorphism)
                _buildSpecificProductDetails(product),

                const SizedBox(height: 20),

                // Created at - Format tanggal lebih baik
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      "Created: ${AppFormatters.formatDate(product.createdAt)}",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),

                // Show relative time
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 18, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      AppFormatters.formatRelativeTime(product.createdAt),
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Action Button (based on type)
                _buildActionButton(context, product),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to safely get status display name
  String _getStatusDisplayName(dynamic status) {
    if (status == null) return 'ACTIVE';

    if (status is ProductStatus) {
      return status.displayName.toUpperCase();
    }

    // Fallback: convert to string
    return status.toString().split('.').last.toUpperCase();
  }

  // Helper method to get status color
  Color _getStatusColor(dynamic status) {
    if (status == null || status == ProductStatus.active) {
      return Colors.green.shade100;
    }

    if (status == ProductStatus.draft) {
      return Colors.orange.shade100;
    }

    if (status == ProductStatus.inactive) {
      return Colors.grey.shade300;
    }

    return Colors.grey.shade300;
  }

  /// Build different widgets depending on the product type
  Widget _buildSpecificProductDetails(BaseProduct product) {
    if (product is DigitalProduct) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Digital Product Details:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          // Format download count dengan thousand separator
          Row(
            children: [
              const Icon(Icons.cloud_download, color: Colors.blueAccent),
              const SizedBox(width: 6),
              Text("Downloads: ${AppFormatters.formatNumber(product.downloadCount)}"),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.link, color: Colors.blueAccent),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  product.downloadUrl,
                  style: const TextStyle(color: Colors.blue),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      );
    } else if (product is PhysicalProduct) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Physical Product Details:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          // Format stock dengan thousand separator & warning color
          Row(
            children: [
              Icon(
                Icons.inventory,
                color: product.stock > 10
                    ? Colors.green
                    : product.stock > 0
                        ? Colors.orange
                        : Colors.red,
              ),
              const SizedBox(width: 6),
              Text(
                "Stock: ${AppFormatters.formatNumber(product.stock)} items",
                style: TextStyle(
                  color: product.stock > 10
                      ? Colors.green
                      : product.stock > 0
                          ? Colors.orange
                          : Colors.red,
                  fontWeight: product.stock < 10 ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              // Low stock badge
              if (product.stock > 0 && product.stock < 10)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: const Text(
                    'Low Stock',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              else if (product.stock == 0)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.red),
                  ),
                  child: const Text(
                    'Out of Stock',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          // Format weight dengan decimal
          Row(
            children: [
              const Icon(Icons.monitor_weight, color: Colors.green),
              const SizedBox(width: 6),
              Text("Weight: ${AppFormatters.formatNumberWithDecimal(product.weight, decimalDigits: 2)} kg"),
            ],
          ),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  /// Action button depends on product type
  Widget _buildActionButton(BuildContext context, BaseProduct product) {
    if (product is DigitalProduct) {
      return ElevatedButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Opening download link...")),
          );
        },
        icon: const Icon(Icons.download),
        label: const Text("Download Now"),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0D9488),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } else if (product is PhysicalProduct) {
      // Disable button jika stock habis
      final isOutOfStock = product.stock == 0;

      return ElevatedButton.icon(
        onPressed: isOutOfStock
            ? null
            : () async {
                // prevent double-tap
                if (_isAdding) return;
                setState(() => _isAdding = true);

                final success = await CartService.addToCart(product, quantity: 1);

                // Immediately check mounted before using context or calling setState
                if (!mounted) {
                  return;
                }

                setState(() => _isAdding = false);

                if (success) {

                   if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Added to cart")),
                  );
                } else {
                  
                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Failed to add to cart"), 
                    backgroundColor: Colors.red),
                  );
                }
              },
        icon: _isAdding ? SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Icon(isOutOfStock ? Icons.block : Icons.shopping_cart),
        label: Text(isOutOfStock ? "Out of Stock" : (_isAdding ? "Adding..." : "Add to Cart")),
        style: ElevatedButton.styleFrom(
          backgroundColor: isOutOfStock ? Colors.grey : Colors.green,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
