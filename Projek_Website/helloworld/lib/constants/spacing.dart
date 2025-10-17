// lib/constants/spacing.dart
import 'package:flutter/material.dart';
import 'breakpoints.dart';

class AppSpacing {
  // Base spacing unit
  static const double unit = 8.0;

  static double? get radiusMd => null;

  static double? get radiusSm => null;
  
  // Responsive spacing
  static double xs(BuildContext context) => 
    _getResponsiveSpacing(context, mobile: 4, tablet: 4, desktop: 8);
  
  static double sm(BuildContext context) => 
    _getResponsiveSpacing(context, mobile: 8, tablet: 12, desktop: 16);
  
  static double md(BuildContext context) => 
    _getResponsiveSpacing(context, mobile: 16, tablet: 20, desktop: 24);
  
  static double lg(BuildContext context) => 
    _getResponsiveSpacing(context, mobile: 24, tablet: 32, desktop: 40);
  
  static double xl(BuildContext context) => 
    _getResponsiveSpacing(context, mobile: 32, tablet: 48, desktop: 64);
  
  static double _getResponsiveSpacing(
    BuildContext context, {
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    final width = MediaQuery.of(context).size.width;
    if (width >= Breakpoints.desktop) return desktop;
    if (width >= Breakpoints.tablet) return tablet;
    return mobile;
  }
}