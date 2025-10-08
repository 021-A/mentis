// lib/screens/detail/product_detail_screen.dart
import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../services/product_service.dart';

class ProductDetailScreen extends StatelessWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId, required BaseProduct product});

  @override
  Widget build(BuildContext context) {
    final product = ProductService.getProductById(productId);

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Product Detail")),
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
        backgroundColor: Colors.blueAccent,
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
                    Chip(
                      label: Text(
                        product.status.name.toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: product.status == ProductStatus.active
                          ? Colors.green.shade100
                          : Colors.grey.shade300,
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

                // Price
                Row(
                  children: [
                    const Icon(Icons.price_change, color: Colors.orange),
                    const SizedBox(width: 8),
                    Text(
                      "\$${product.price.toStringAsFixed(2)}",
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

                // Created at
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      "Created: ${product.createdAt.toLocal().toString().split(' ')[0]}",
                      style: const TextStyle(fontSize: 14),
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
          Row(
            children: [
              const Icon(Icons.cloud_download, color: Colors.blueAccent),
              const SizedBox(width: 6),
              Text("Downloads: ${product.downloadCount}"),
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
          Row(
            children: [
              const Icon(Icons.inventory, color: Colors.green),
              const SizedBox(width: 6),
              Text("Stock: ${product.stock} items"),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.monitor_weight, color: Colors.green),
              const SizedBox(width: 6),
              Text("Weight: ${product.weight} kg"),
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
          backgroundColor: Colors.blueAccent,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } else if (product is PhysicalProduct) {
      return ElevatedButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Added to cart")),
          );
        },
        icon: const Icon(Icons.shopping_cart),
        label: const Text("Add to Cart"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
