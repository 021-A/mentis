// lib/screens/products/products_screen.dart
import 'package:flutter/material.dart';
import '../../models/product.dart';
import 'add_product_screen.dart';
import '../detail/product_detail_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  // Dummy data (sementara, nanti bisa diganti dengan ProductService / API)
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
  ];

  /// Tambah atau edit produk
  Future<void> _navigateToAddOrEdit([BaseProduct? product]) async {
    final BaseProduct? result = await Navigator.push<BaseProduct?>(
      context,
      MaterialPageRoute(builder: (_) => AddProductScreen(product: product)),
    );

    if (result != null) {
      setState(() {
        if (product == null) {
          // Tambah produk baru
          _products.add(result);
        } else {
          // Update produk lama
          final index = _products.indexWhere((p) => p.id == product.id);
          if (index != -1) {
            _products[index] = result;
          }
        }
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(product == null
              ? "${result.title} berhasil ditambahkan."
              : "${result.title} berhasil diperbarui."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: "Tambah Produk",
            onPressed: () => _navigateToAddOrEdit(),
          ),
        ],
      ),
      body: _products.isEmpty
          ? const Center(
              child: Text("Belum ada produk. Tambahkan produk baru."),
            )
          : ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: Icon(
                      product is DigitalProduct
                          ? Icons.cloud_download
                          : Icons.inventory,
                      color: Colors.blue,
                    ),
                    title: Text(product.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.description,
                            maxLines: 2, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        if (product is DigitalProduct)
                          Text("Downloads: ${product.downloadCount}")
                        else if (product is PhysicalProduct)
                          Text("Stock: ${product.stock} • Weight: ${product.weight}kg"),
                        Text("Price: \$${product.price.toStringAsFixed(2)}"),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.orange),
                      onPressed: () => _navigateToAddOrEdit(product),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailScreen(product: product, productId: '',),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
