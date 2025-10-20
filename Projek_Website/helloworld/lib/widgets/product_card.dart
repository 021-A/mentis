// lib/widgets/product_card.dart
// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import '../models/product.dart';
import '../utils/formatters.dart';
import '../utils/image_helper.dart';

class ProductCard extends StatelessWidget {
  final BaseProduct product;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showActions;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Product image with ImageHelper
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D9488).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                          ? ImageHelper.getImageWidget(
                              product.imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorWidget: const Icon(
                                Icons.inventory,
                                color: Color(0xFF0D9488),
                                size: 30,
                              ),
                            )
                          : const Icon(
                              Icons.inventory,
                              color: Color(0xFF0D9488),
                              size: 30,
                            ),
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Product info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        // Category badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getCategoryColor().withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            product.category,
                            style: TextStyle(
                              color: _getCategoryColor(),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Format price dengan Rupiah
                        Text(
                          AppFormatters.formatCurrency(product.price),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0D9488),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Actions
                  if (showActions)
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert),
                      onSelected: (value) {
                        switch (value) {
                          case 'edit':
                            onEdit?.call();
                            break;
                          case 'delete':
                            onDelete?.call();
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 18),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 18, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Delete', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Product description
              Text(
                product.description,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 12),
              
              // Additional info based on product type
              Row(
                children: [
                  _buildProductTypeInfo(),
                  const Spacer(),
                  // Show created date with relative time
                  if (product.createdAt != null)
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 12,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          AppFormatters.formatRelativeTime(product.createdAt),
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductTypeInfo() {
    if (product is DigitalProduct) {
      final digitalProduct = product as DigitalProduct;
      return Row(
        children: [
          const Icon(Icons.download, size: 14, color: Colors.blue),
          const SizedBox(width: 4),
          // Format download count dengan thousand separator
          Text(
            '${AppFormatters.formatNumber(digitalProduct.downloadCount)} downloads',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.blue,
            ),
          ),
        ],
      );
    } else if (product is PhysicalProduct) {
      final physicalProduct = product as PhysicalProduct;
      // Color coding untuk stock
      final stockColor = physicalProduct.stock > 10
          ? Colors.green
          : physicalProduct.stock > 0
              ? Colors.orange
              : Colors.red;
      
      return Row(
        children: [
          Icon(Icons.inventory_2, size: 14, color: stockColor),
          const SizedBox(width: 4),
          Text(
            'Stock: ${AppFormatters.formatNumber(physicalProduct.stock)}',
            style: TextStyle(
              fontSize: 12,
              color: stockColor,
              fontWeight: physicalProduct.stock < 5 ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          // Low stock warning
          if (physicalProduct.stock > 0 && physicalProduct.stock < 5)
            Container(
              margin: const EdgeInsets.only(left: 6),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.orange, width: 0.5),
              ),
              child: const Text(
                'Low Stock',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else if (physicalProduct.stock == 0)
            Container(
              margin: const EdgeInsets.only(left: 6),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.red, width: 0.5),
              ),
              child: const Text(
                'Out of Stock',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  // Get category color dynamically
  Color _getCategoryColor() {
    switch (product.category.toLowerCase()) {
      case 'e-book':
        return const Color(0xFF8B5CF6); // Purple
      case 'course':
        return const Color(0xFF3B82F6); // Blue
      case 'template':
        return const Color(0xFF10B981); // Green
      case 'software':
        return const Color(0xFFF59E0B); // Amber
      case 'audio':
        return const Color(0xFFEC4899); // Pink
      case 'video':
        return const Color(0xFFEF4444); // Red
      default:
        return const Color(0xFF6B7280); // Gray
    }
  }
}