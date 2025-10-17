// lib/utils/screen_size.dart
import 'package:flutter/material.dart';
import '../constants/breakpoints.dart';

/// Additional device type enum (optional).
enum DeviceType { mobile, tablet, desktop, largeDesktop }

/// Screen size categories used in the project.
enum ScreenSizeType { mobile, tablet, desktop }

/// Utility class to query screen info and provide responsive helpers.
class ScreenSize {
  final BuildContext context;

  ScreenSize(this.context);

  /// Convenient accessor
  static ScreenSize of(BuildContext context) => ScreenSize(context);

  // Get screen dimensions
  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;

  // Device type detection
  bool get isMobile => width < Breakpoints.tablet;
  bool get isTablet => width >= Breakpoints.tablet && width < Breakpoints.desktop;
  bool get isDesktop => width >= Breakpoints.desktop;
  bool get isLargeDesktop => width >= Breakpoints.largeDesktop;

  DeviceType get deviceType {
    if (isLargeDesktop) return DeviceType.largeDesktop;
    if (isDesktop) return DeviceType.desktop;
    if (isTablet) return DeviceType.tablet;
    return DeviceType.mobile;
  }

  /// Map to ScreenSizeType (if you need this enum elsewhere)
  ScreenSizeType get screenSizeType {
    if (isDesktop) return ScreenSizeType.desktop;
    if (isTablet) return ScreenSizeType.tablet;
    return ScreenSizeType.mobile;
  }

  // Responsive values — prefer to always provide `mobile`, others optional.
  T responsive<T>({
    required T mobile,
    T? tablet,
    T? desktop,
    T? largeDesktop,
  }) {
    if (isLargeDesktop && largeDesktop != null) return largeDesktop;
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }

  // Grid columns based on screen size
  int get gridColumns {
    if (isLargeDesktop) return 4;
    if (isDesktop) return 3;
    if (isTablet) return 2;
    return 1;
  }

  // Orientation
  bool get isPortrait => height >= width;
  bool get isLandscape => width > height;
}
