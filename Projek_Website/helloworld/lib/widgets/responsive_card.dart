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
  final bool mobile; // <--- tambahkan ini

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
    this.mobile = false, // default false
  });

  @override
  Widget build(BuildContext context) {
    final screen = context.screen;
    
    final responsiveBorderRadius = borderRadius ?? screen.responsive(
      mobile: 12,
      tablet: 14,
      desktop: 16,
    );

    final responsivePadding = padding ?? EdgeInsets.all(
      screen.responsive(
        mobile: 16,
        tablet: 20,
        desktop: 24,
      ),
    );

    final responsiveMargin = margin ?? EdgeInsets.all(
      screen.responsive(
        mobile: 8,
        tablet: 12,
        desktop: 16,
      ),
    );

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

// Variant Material Design 3
class ResponsiveCardM3 extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final double? elevation;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final bool mobile; // <--- tambahkan ini

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
    this.mobile = false, // default false
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

// Perbaikan ResponsiveSectionCard: hapus required subtitle yang salah
class ResponsiveSectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;
  final VoidCallback? onTitleTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool showDivider;
  final bool mobile; // <--- tambahkan

  const ResponsiveSectionCard({
    super.key,
    required this.title,
    required this.child,
    this.trailing,
    this.onTitleTap,
    this.padding,
    this.margin,
    this.showDivider = true,
    this.mobile = false, // default false
  });

  @override
  Widget build(BuildContext context) {
    final screen = context.screen;

    return ResponsiveCard(
      padding: EdgeInsets.zero,
      margin: margin,
      mobile: mobile, // <--- pasang parameter
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          if (showDivider) const Divider(height: 1),
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
