import 'package:flutter/material.dart';
import '../constants/breakpoints.dart';

class ResponsiveUtils {
  // Menghitung lebar kolom grid berdasarkan total lebar
  static int calculateGridColumns(double width, {
    int mobileColumns = 1,
    int tabletColumns = 2,
    int desktopColumns = 3,
    int largeDesktopColumns = 4,
  }) {
    if (width >= Breakpoints.largeDesktop) return largeDesktopColumns;
    if (width >= Breakpoints.desktop) return desktopColumns;
    if (width >= Breakpoints.tablet) return tabletColumns;
    return mobileColumns;
  }

  // Menghitung spacing responsif
  static double getResponsiveSpacing(
    BuildContext context, {
    double mobile = 16.0,
    double tablet = 24.0,
    double desktop = 32.0,
  }) {
    final width = MediaQuery.of(context).size.width;
    if (width >= Breakpoints.desktop) return desktop;
    if (width >= Breakpoints.tablet) return tablet;
    return mobile;
  }

  // Menghitung font size responsif
  static double getResponsiveFontSize(
    BuildContext context, {
    double mobile = 14.0,
    double tablet = 16.0,
    double desktop = 16.0,
  }) {
    final width = MediaQuery.of(context).size.width;
    if (width >= Breakpoints.desktop) return desktop;
    if (width >= Breakpoints.tablet) return tablet;
    return mobile;
  }

  // Menghitung padding responsif berdasarkan screen size
  static EdgeInsets getResponsivePadding(
    BuildContext context, {
    EdgeInsets? mobile,
    EdgeInsets? tablet,
    EdgeInsets? desktop,
  }) {
    final width = MediaQuery.of(context).size.width;
    
    final defaultMobile = mobile ?? const EdgeInsets.all(16);
    final defaultTablet = tablet ?? const EdgeInsets.all(24);
    final defaultDesktop = desktop ?? const EdgeInsets.all(32);

    if (width >= Breakpoints.desktop) return defaultDesktop;
    if (width >= Breakpoints.tablet) return defaultTablet;
    return defaultMobile;
  }

  // Menghitung max width untuk content container
  static double getMaxContentWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= Breakpoints.largeDesktop) return 1200;
    if (width >= Breakpoints.desktop) return 1000;
    if (width >= Breakpoints.tablet) return 800;
    return width;
  }

  // Check orientation
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  // Mendapatkan aspect ratio responsif untuk gambar/card
  static double getResponsiveAspectRatio(
    BuildContext context, {
    double mobile = 1.0,
    double tablet = 1.2,
    double desktop = 1.3,
  }) {
    final width = MediaQuery.of(context).size.width;
    if (width >= Breakpoints.desktop) return desktop;
    if (width >= Breakpoints.tablet) return tablet;
    return mobile;
  }

  // Mendapatkan dialog width responsif
  static double getDialogWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= Breakpoints.desktop) return 600;
    if (width >= Breakpoints.tablet) return 500;
    return width * 0.9; // 90% dari lebar layar untuk mobile
  }

  // Cek apakah harus show sidebar
  static bool shouldShowSidebar(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= Breakpoints.desktop;
  }

  // Cek apakah harus show bottom navigation
  static bool shouldShowBottomNav(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width < Breakpoints.tablet;
  }

  // Mendapatkan icon size responsif
  static double getResponsiveIconSize(
    BuildContext context, {
    double mobile = 24.0,
    double tablet = 28.0,
    double desktop = 32.0,
  }) {
    final width = MediaQuery.of(context).size.width;
    if (width >= Breakpoints.desktop) return desktop;
    if (width >= Breakpoints.tablet) return tablet;
    return mobile;
  }

  // Mendapatkan card elevation responsif
  static double getResponsiveElevation(
    BuildContext context, {
    double mobile = 2.0,
    double tablet = 3.0,
    double desktop = 4.0,
  }) {
    final width = MediaQuery.of(context).size.width;
    if (width >= Breakpoints.desktop) return desktop;
    if (width >= Breakpoints.tablet) return tablet;
    return mobile;
  }

  // Mendapatkan border radius responsif
  static BorderRadius getResponsiveBorderRadius(
    BuildContext context, {
    double mobile = 8.0,
    double tablet = 12.0,
    double desktop = 16.0,
  }) {
    final width = MediaQuery.of(context).size.width;
    double radius = mobile;
    
    if (width >= Breakpoints.desktop) {
      radius = desktop;
    } else if (width >= Breakpoints.tablet) {
      radius = tablet;
    }
    
    return BorderRadius.circular(radius);
  }

  // Scale value berdasarkan screen width
  static double scaleValue(
    BuildContext context,
    double baseValue, {
    double mobileScale = 1.0,
    double tabletScale = 1.2,
    double desktopScale = 1.5,
  }) {
    final width = MediaQuery.of(context).size.width;
    
    if (width >= Breakpoints.desktop) {
      return baseValue * desktopScale;
    } else if (width >= Breakpoints.tablet) {
      return baseValue * tabletScale;
    }
    return baseValue * mobileScale;
  }
}