// lib/widgets/responsive_card.dart
import 'package:flutter/material.dart';
import '../extensions/responsive_extensions.dart';
// ignore: unused_import
import '../constants/breakpoints.dart';

class ResponsiveCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final bool showShadow;
  final double? borderRadius;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const ResponsiveCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.showShadow = true,
    this.borderRadius,
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screen = context.screen;
    
    // Responsive border radius
    final responsiveBorderRadius = borderRadius ?? screen.responsive(
      mobile: 12,
      tablet: 14,
      desktop: 16,
    );
    
    // Responsive padding
    final responsivePadding = padding ?? EdgeInsets.all(
      screen.responsive(
        mobile: 16,
        tablet: 20,
        desktop: 24,
      ),
    );
    
    // Responsive margin
    final responsiveMargin = margin ?? EdgeInsets.all(
      screen.responsive(
        mobile: 8,
        tablet: 12,
        desktop: 16,
      ),
    );
    
    // Responsive elevation
    final responsiveElevation = screen.responsive(
      mobile: 2.0,
      tablet: 3.0,
      desktop: 4.0,
    );

    final cardContent = Container(
      width: width,
      height: height,
      margin: responsiveMargin,
      padding: responsivePadding,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(responsiveBorderRadius!),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: responsiveElevation * 2.5,
                  offset: Offset(0, responsiveElevation),
                ),
              ]
            : null,
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(responsiveBorderRadius),
        child: cardContent,
      );
    }

    return cardContent;
  }
}

// Variant dengan Material Design 3
class ResponsiveCardM3 extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final double? elevation;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const ResponsiveCardM3({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.elevation,
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screen = context.screen;
    
    return Card(
      elevation: elevation ?? screen.responsive(
        mobile: 1.0,
        tablet: 2.0,
        desktop: 3.0,
      ),
      margin: margin ?? EdgeInsets.all(
        screen.responsive(mobile: 8, tablet: 12, desktop: 16),
      ),
      color: backgroundColor,
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
        child: Container(
          width: width,
          height: height,
          padding: padding ?? EdgeInsets.all(
            screen.responsive(mobile: 16, tablet: 20, desktop: 24),
          ),
          child: child,
        ),
      ),
    );
  }
}

// Section Card dengan Header
class ResponsiveSectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;
  final VoidCallback? onTitleTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool showDivider;

  const ResponsiveSectionCard({
    super.key,
    required this.title,
    required this.child,
    this.trailing,
    this.onTitleTap,
    this.padding,
    this.margin,
    this.showDivider = true, required String subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final screen = context.screen;
    
    return ResponsiveCard(
      padding: EdgeInsets.zero,
      margin: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          InkWell(
            onTap: onTitleTap,
            child: Padding(
              padding: EdgeInsets.all(
                screen.responsive(mobile: 16, tablet: 18, desktop: 20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: screen.responsive(
                        mobile: 16,
                        tablet: 17,
                        desktop: 18,
                      ),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (trailing != null) trailing!,
                ],
              ),
            ),
          ),
          
          // Divider
          if (showDivider) const Divider(height: 1),
          
          // Content
          Padding(
            padding: padding ?? EdgeInsets.all(
              screen.responsive(mobile: 16, tablet: 18, desktop: 20),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}

// Outlined Card variant
class ResponsiveOutlinedCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final Color? borderColor;
  final double? borderWidth;
  final VoidCallback? onTap;

  const ResponsiveOutlinedCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.borderColor,
    this.borderWidth,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screen = context.screen;
    
    final responsiveBorderRadius = screen.responsive(
      mobile: 12.0,
      tablet: 14.0,
      desktop: 16.0,
    );

    final cardContent = Container(
      width: width,
      height: height,
      margin: margin ?? EdgeInsets.all(
        screen.responsive(mobile: 8, tablet: 12, desktop: 16),
      ),
      padding: padding ?? EdgeInsets.all(
        screen.responsive(mobile: 16, tablet: 20, desktop: 24),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsiveBorderRadius),
        border: Border.all(
          color: borderColor ?? Colors.grey.shade300,
          width: borderWidth ?? 1,
        ),
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(responsiveBorderRadius),
        child: cardContent,
      );
    }

    return cardContent;
  }
}

// Gradient Card variant
class ResponsiveGradientCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final List<Color>? gradientColors;
  final AlignmentGeometry? gradientBegin;
  final AlignmentGeometry? gradientEnd;
  final VoidCallback? onTap;

  const ResponsiveGradientCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.gradientColors,
    this.gradientBegin,
    this.gradientEnd,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screen = context.screen;
    
    final responsiveBorderRadius = screen.responsive(
      mobile: 12.0,
      tablet: 14.0,
      desktop: 16.0,
    );

    final defaultGradient = [
      const Color(0xFF0D9488),
      const Color(0xFF14B8A6),
    ];

    final cardContent = Container(
      width: width,
      height: height,
      margin: margin ?? EdgeInsets.all(
        screen.responsive(mobile: 8, tablet: 12, desktop: 16),
      ),
      padding: padding ?? EdgeInsets.all(
        screen.responsive(mobile: 16, tablet: 20, desktop: 24),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(responsiveBorderRadius),
        gradient: LinearGradient(
          begin: gradientBegin ?? Alignment.topLeft,
          end: gradientEnd ?? Alignment.bottomRight,
          colors: gradientColors ?? defaultGradient,
        ),
        boxShadow: [
          BoxShadow(
            color: (gradientColors?.first ?? defaultGradient.first)
                .withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(responsiveBorderRadius),
        child: cardContent,
      );
    }

    return cardContent;
  }
}

// Glass Morphism Card variant
class ResponsiveGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final double blur;
  final double opacity;
  final VoidCallback? onTap;

  const ResponsiveGlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.blur = 10,
    this.opacity = 0.1,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screen = context.screen;
    
    final responsiveBorderRadius = screen.responsive(
      mobile: 12.0,
      tablet: 14.0,
      desktop: 16.0,
    );

    final cardContent = Container(
      width: width,
      height: height,
      margin: margin ?? EdgeInsets.all(
        screen.responsive(mobile: 8, tablet: 12, desktop: 16),
      ),
      padding: padding ?? EdgeInsets.all(
        screen.responsive(mobile: 16, tablet: 20, desktop: 24),
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: opacity),
        borderRadius: BorderRadius.circular(responsiveBorderRadius),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: blur,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(responsiveBorderRadius),
        child: cardContent,
      );
    }

    return cardContent;
  }
}