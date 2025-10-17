// lib/extensions/responsive_extensions.dart
// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import '../utils/screen_size.dart';
import '../constants/breakpoints.dart';

extension ResponsiveContext on BuildContext {
  ScreenSize get screen => ScreenSize(this);
  
  bool get isMobile => screen.isMobile;
  bool get isTablet => screen.isTablet;
  bool get isDesktop => screen.isDesktop;
  
  // Shorthand untuk responsive value
  T responsive<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    return screen.responsive(
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }
  
  // Responsive padding
  EdgeInsets get responsivePadding {
    return EdgeInsets.all(screen.responsive(
      mobile: 16,
      tablet: 24,
      desktop: 32,
    ));
  }
  
  // Responsive font sizes
  double get titleSize => screen.responsive(
    mobile: 20,
    tablet: 24,
    desktop: 28,
  );
  
  double get bodySize => screen.responsive(
    mobile: 14,
    tablet: 16,
    desktop: 16,
  );
  
  // ===== METHODS YANG HILANG - DITAMBAHKAN =====
  
  // Responsive font size method (untuk custom sizes)
  double responsiveFontSize(int i, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    return screen.responsive(
      mobile: mobile,
      tablet: tablet ?? mobile * 1.1,
      desktop: desktop ?? mobile * 1.2,
    );
  }
  
  // Responsive icon size
  double responsiveIconSize(int i, {
    double mobile = 24,
    double? tablet,
    double? desktop,
  }) {
    return screen.responsive(
      mobile: mobile,
      tablet: tablet ?? mobile * 1.1,
      desktop: desktop ?? mobile * 1.2,
    );
  }
  
  // Responsive spacing variants
  double get responsiveSpacing => screen.responsive(
    mobile: 16,
    tablet: 20,
    desktop: 24,
  );
  
  double get responsiveSmallSpacing => screen.responsive(
    mobile: 8,
    tablet: 10,
    desktop: 12,
  );
  
  double get responsiveMediumSpacing => screen.responsive(
    mobile: 16,
    tablet: 20,
    desktop: 24,
  );
  
  double get responsiveLargeSpacing => screen.responsive(
    mobile: 24,
    tablet: 32,
    desktop: 40,
  );
  
  double get responsiveExtraLargeSpacing => screen.responsive(
    mobile: 32,
    tablet: 48,
    desktop: 64,
  );
  
  // Responsive margins
  EdgeInsets get responsiveMargin => EdgeInsets.all(
    screen.responsive(mobile: 8, tablet: 12, desktop: 16),
  );
  
  EdgeInsets get responsiveSmallMargin => EdgeInsets.all(
    screen.responsive(mobile: 4, tablet: 6, desktop: 8),
  );
  
  EdgeInsets get responsiveLargeMargin => EdgeInsets.all(
    screen.responsive(mobile: 16, tablet: 24, desktop: 32),
  );
  
  // Responsive border radius
  double get responsiveBorderRadius => screen.responsive(
    mobile: 8,
    tablet: 12,
    desktop: 16,
  );
  
  double get responsiveSmallBorderRadius => screen.responsive(
    mobile: 4,
    tablet: 6,
    desktop: 8,
  );
  
  double get responsiveLargeBorderRadius => screen.responsive(
    mobile: 12,
    tablet: 16,
    desktop: 20,
  );
  
  // Responsive elevation
  double get responsiveElevation => screen.responsive(
    mobile: 2,
    tablet: 3,
    desktop: 4,
  );
  
  // Helper untuk widget size
  double get responsiveButtonHeight => screen.responsive(
    mobile: 48,
    tablet: 52,
    desktop: 56,
  );
  
  double get responsiveButtonWidth => screen.responsive(
    mobile: double.infinity,
    tablet: 300,
    desktop: 400,
  );
  
  // Helper untuk dialog/modal
  double get responsiveDialogWidth => screen.responsive(
    mobile: MediaQuery.of(this).size.width * 0.9,
    tablet: 500,
    desktop: 600,
  );
  
  // Helper untuk card dimensions
  double get responsiveCardHeight => screen.responsive(
    mobile: 200,
    tablet: 250,
    desktop: 300,
  );
  
  // Responsive image size
  double get responsiveImageSize => screen.responsive(
    mobile: 80,
    tablet: 100,
    desktop: 120,
  );
  
  // Responsive avatar size
  double get responsiveAvatarSize => screen.responsive(
    mobile: 40,
    tablet: 48,
    desktop: 56,
  );
  
  // Responsive max width untuk content
  double get responsiveMaxWidth => screen.responsive(
    mobile: double.infinity,
    tablet: 800,
    desktop: 1200,
  );
  
  // Helper untuk check screen type
  bool get isSmallMobile => MediaQuery.of(this).size.width < 375;
  bool get isLargeMobile => MediaQuery.of(this).size.width >= 375 && 
                            MediaQuery.of(this).size.width < 768;
}