// lib/widgets/product_card.dart
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../extensions/responsive_extensions.dart';

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
    final screen = context.screen;
    
    return Card(
      elevation: screen.responsive(
        mobile: 2,
        tablet: 2,
        desktop: 3,
      ),
      margin: EdgeInsets.only(
        bottom: screen.responsive(mobile: 12, tablet: 14, desktop: 16),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          screen.responsive(mobile: 12, tablet: 14, desktop: 16),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          screen.responsive(mobile: 12, tablet: 14, desktop: 16),
        ),
        child: Padding(
          padding: EdgeInsets.all(
            screen.responsive(mobile: 12, tablet: 14, desktop: 16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Product image placeholder
                  Container(
                    width: screen.responsive(
                      mobile: 60,
                      tablet: 70,
                      desktop: 80,
                    ),
                    height: screen.responsive(
                      mobile: 60,
                      tablet: 70,
                      desktop: 80,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D9488).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(
                        screen.responsive(mobile: 8, tablet: 10, desktop: 12),
                      ),
                    ),
                    child: Icon(
                      Icons.inventory,
                      color: const Color(0xFF0D9488),
                      size: screen.responsive(
                        mobile: 30,
                        tablet: 35,
                        desktop: 40,
                      ),
                    ),
                  ),
                  
                  SizedBox(
                    width: screen.responsive(mobile: 12, tablet: 14, desktop: 16),
                  ),
                  
                  // Product info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          style: TextStyle(
                            fontSize: screen.responsive(
                              mobile: 15,
                              tablet: 16,
                              desktop: 16,
                            ),
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: screen.responsive(mobile: 3, tablet: 3.5, desktop: 4),
                        ),
                        Text(
                          product.category,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: screen.responsive(
                              mobile: 11,
                              tablet: 12,
                              desktop: 12,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: screen.responsive(mobile: 6, tablet: 7, desktop: 8),
                        ),
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: screen.responsive(
                              mobile: 16,
                              tablet: 17,
                              desktop: 18,
                            ),
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0D9488),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Actions
                  if (showActions)
                    PopupMenuButton<String>(
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
                      icon: Icon(
                        Icons.more_vert,
                        size: screen.responsive(
                          mobile: 20,
                          tablet: 22,
                          desktop: 24,
                        ),
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(
                                Icons.edit,
                                size: screen.responsive(
                                  mobile: 16,
                                  tablet: 17,
                                  desktop: 18,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Edit',
                                style: TextStyle(
                                  fontSize: screen.responsive(
                                    mobile: 13,
                                    tablet: 14,
                                    desktop: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete,
                                size: screen.responsive(
                                  mobile: 16,
                                  tablet: 17,
                                  desktop: 18,
                                ),
                                color: Colors.red,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Delete',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: screen.responsive(
                                    mobile: 13,
                                    tablet: 14,
                                    desktop: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              
              SizedBox(
                height: screen.responsive(mobile: 10, tablet: 11, desktop: 12),
              ),
              
              // Product description
              Text(
                product.description,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: screen.responsive(
                    mobile: 13,
                    tablet: 13.5,
                    desktop: 14,
                  ),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              SizedBox(
                height: screen.responsive(mobile: 10, tablet: 11, desktop: 12),
              ),
              
              // Additional info based on product type
              Row(
                children: [
                  _buildProductTypeInfo(context),
                  const Spacer(),
                  Text(
                    product.getDisplayInfo(),
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: screen.responsive(
                        mobile: 11,
                        tablet: 11.5,
                        desktop: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductTypeInfo(BuildContext context) {
    final screen = context.screen;
    
    if (product is DigitalProduct) {
      final digitalProduct = product as DigitalProduct;
      return Row(
        children: [
          Icon(
            Icons.download,
            size: screen.responsive(
              mobile: 13,
              tablet: 13.5,
              desktop: 14,
            ),
            color: Colors.blue,
          ),
          const SizedBox(width: 4),
          Text(
            '${digitalProduct.downloadCount} downloads',
            style: TextStyle(
              fontSize: screen.responsive(
                mobile: 11,
                tablet: 11.5,
                desktop: 12,
              ),
              color: Colors.blue,
            ),
          ),
        ],
      );
    } else if (product is PhysicalProduct) {
      final physicalProduct = product as PhysicalProduct;
      return Row(
        children: [
          Icon(
            Icons.inventory_2,
            size: screen.responsive(
              mobile: 13,
              tablet: 13.5,
              desktop: 14,
            ),
            color: Colors.orange,
          ),
          const SizedBox(width: 4),
          Text(
            'Stock: ${physicalProduct.stock}',
            style: TextStyle(
              fontSize: screen.responsive(
                mobile: 11,
                tablet: 11.5,
                desktop: 12,
              ),
              color: Colors.orange,
            ),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }
}

// Grid ProductCard variant (untuk GridView)
class GridProductCard extends StatelessWidget {
  final BaseProduct product;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showActions;

  const GridProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    final screen = context.screen;
    
    return Card(
      elevation: screen.responsive(
        mobile: 2,
        tablet: 2,
        desktop: 3,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          screen.responsive(mobile: 12, tablet: 14, desktop: 16),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          screen.responsive(mobile: 12, tablet: 14, desktop: 16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF0D9488).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                      screen.responsive(mobile: 12, tablet: 14, desktop: 16),
                    ),
                    topRight: Radius.circular(
                      screen.responsive(mobile: 12, tablet: 14, desktop: 16),
                    ),
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        Icons.inventory,
                        color: const Color(0xFF0D9488),
                        size: screen.responsive(
                          mobile: 48,
                          tablet: 56,
                          desktop: 64,
                        ),
                      ),
                    ),
                    if (showActions)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: PopupMenuButton<String>(
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
                          icon: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.more_vert,
                              size: screen.responsive(
                                mobile: 18,
                                tablet: 20,
                                desktop: 22,
                              ),
                            ),
                          ),
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
                      ),
                  ],
                ),
              ),
            ),
            
            // Product Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(
                  screen.responsive(mobile: 10, tablet: 12, desktop: 14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: TextStyle(
                        fontSize: screen.responsive(
                          mobile: 14,
                          tablet: 15,
                          desktop: 16,
                        ),
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.category,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: screen.responsive(
                          mobile: 11,
                          tablet: 12,
                          desktop: 12,
                        ),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: screen.responsive(
                          mobile: 16,
                          tablet: 17,
                          desktop: 18,
                        ),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0D9488),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}