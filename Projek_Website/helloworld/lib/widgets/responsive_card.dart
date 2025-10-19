// lib/widgets/responsive_card.dart
import 'package:flutter/material.dart';

class ResponsiveCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final bool showShadow;
  final double borderRadius;

  const ResponsiveCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.showShadow = true,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;
        
        return Container(
          width: width,
          height: height,
          margin: margin ?? EdgeInsets.all(isSmallScreen ? 8 : 16),
          padding: padding ?? EdgeInsets.all(isSmallScreen ? 16 : 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: showShadow
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: child,
        );
      },
    );
  }
}