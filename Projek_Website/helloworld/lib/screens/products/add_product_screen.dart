import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helloworld/models/product.dart';

class AddProductScreen extends StatefulWidget {
  final BaseProduct? product; // opsional (null = add, ada = edit)

  const AddProductScreen({super.key, this.product});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _categoryController;
  
  String _productType = 'Digital'; // Digital or Physical

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.title ?? '');
    _priceController = TextEditingController(
      text: widget.product != null ? widget.product!.price.toString() : '',
    );
    _descriptionController = TextEditingController(
      text: widget.product?.description ?? '',
    );
    _categoryController = TextEditingController(
      text: widget.product?.category ?? '',
    );
    
    // Tentukan product type dari existing product
    if (widget.product != null) {
      _productType = widget.product is DigitalProduct ? 'Digital' : 'Physical';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  double _parsePrice(String text) {
    // aman memparsing, mengganti koma dengan titik bila perlu
    final normalized = text.replaceAll(',', '.');
    return double.tryParse(normalized) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Edit Product" : "Add Product"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Type Selector (hanya untuk add new product)
              if (!isEditing) ...[
                const Text(
                  "Product Type",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                      value: 'Digital',
                      label: Text('Digital'),
                      icon: Icon(Icons.cloud_download),
                    ),
                    ButtonSegment(
                      value: 'Physical',
                      label: Text('Physical'),
                      icon: Icon(Icons.inventory),
                    ),
                  ],
                  selected: {_productType},
                  onSelectionChanged: (Set<String> selected) {
                    setState(() {
                      _productType = selected.first;
                    });
                  },
                ),
                const SizedBox(height: 16),
              ],

              // Nama produk
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Product Name",
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                validator: (value) =>
                    value == null || value.trim().isEmpty ? "Enter product name" : null,
              ),
              const SizedBox(height: 12),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                textInputAction: TextInputAction.next,
                validator: (value) =>
                    value == null || value.trim().isEmpty ? "Enter description" : null,
              ),
              const SizedBox(height: 12),

              // Category
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                validator: (value) =>
                    value == null || value.trim().isEmpty ? "Enter category" : null,
              ),
              const SizedBox(height: 12),

              // Harga produk
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: "Price (numeric)",
                  border: OutlineInputBorder(),
                  prefixText: '\$ ',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return "Enter product price";
                  final p = _parsePrice(value.trim());
                  if (p <= 0) return "Price must be greater than 0";
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        FocusScope.of(context).unfocus();

                        final name = _nameController.text.trim();
                        final description = _descriptionController.text.trim();
                        final category = _categoryController.text.trim();
                        final price = _parsePrice(_priceController.text.trim());

                        // Buat object BaseProduct baru atau update
                        BaseProduct resultProduct;
                        
                        if (isEditing) {
                          // Update existing product
                          if (widget.product is DigitalProduct) {
                            resultProduct = DigitalProduct(
                              id: widget.product!.id,
                              title: name,
                              description: description,
                              price: price,
                              category: category,
                              createdAt: widget.product!.createdAt,
                              downloadUrl: (widget.product as DigitalProduct).downloadUrl,
                              downloadCount: (widget.product as DigitalProduct).downloadCount,
                              status: widget.product!.status,
                            );
                          } else {
                            resultProduct = PhysicalProduct(
                              id: widget.product!.id,
                              title: name,
                              description: description,
                              price: price,
                              category: category,
                              createdAt: widget.product!.createdAt,
                              stock: (widget.product as PhysicalProduct).stock,
                              weight: (widget.product as PhysicalProduct).weight,
                              status: widget.product!.status,
                            );
                          }
                        } else {
                          // Create new product
                          final productId = DateTime.now().millisecondsSinceEpoch.toString();
                          
                          if (_productType == 'Digital') {
                            resultProduct = DigitalProduct(
                              id: productId,
                              title: name,
                              description: description,
                              price: price,
                              category: category,
                              createdAt: DateTime.now(),
                              downloadUrl: 'https://example.com/$productId',
                              downloadCount: 0,
                              status: ProductStatus.active,
                            );
                          } else {
                            resultProduct = PhysicalProduct(
                              id: productId,
                              title: name,
                              description: description,
                              price: price,
                              category: category,
                              createdAt: DateTime.now(),
                              stock: 10,
                              weight: 1.0,
                              status: ProductStatus.active,
                            );
                          }
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isEditing
                                  ? "Updated $name - \$${price.toStringAsFixed(2)}"
                                  : "Added $name - \$${price.toStringAsFixed(2)}",
                            ),
                          ),
                        );

                        // Kembalikan product ke pemanggil (bisa ditangani di then / await)
                        Navigator.pop(context, resultProduct);
                      }
                    },
                    child: Text(isEditing ? "Update Product" : "Save Product"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}