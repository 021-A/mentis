import 'package:flutter/material.dart';
import 'package:helloworld/models/product.dart';

class AddProductScreen extends StatefulWidget {
  final BaseProduct? product; // opsional (null = add, ada = edit)

  const AddProductScreen({super.key, this.product});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _productName;
  late double _price;

  @override
  void initState() {
    super.initState();
    // isi default kalau edit
    _productName = widget.product?.title ?? '';
    _price = widget.product?.price ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Edit Product" : "Add Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _productName,
                decoration: const InputDecoration(labelText: "Product Name"),
                onSaved: (value) => _productName = value ?? '',
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter product name" : null,
              ),
              TextFormField(
                initialValue: _price > 0 ? _price.toString() : '',
                decoration: const InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
                onSaved: (value) => _price = double.tryParse(value ?? '0') ?? 0,
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter product price" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isEditing
                              ? "Updated $_productName - Rp$_price"
                              : "Added $_productName - Rp$_price",
                        ),
                      ),
                    );

                    Navigator.pop(context);
                  }
                },
                child: Text(isEditing ? "Update Product" : "Save Product"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
