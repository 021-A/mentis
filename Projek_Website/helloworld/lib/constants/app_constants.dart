// lib/constants/app_constants.dart
class AppConstants {
  // App Info
  static const String appName = 'MENTIS';
  static const String appTagline = 'Digital Learning Platform';
  static const String creatorName = 'Dedi Firmansyah';
  static const String appVersion = '1.0.0';
  
  // Colors
  static const int primaryColorValue = 0xFF0D9488;
  static const int secondaryColorValue = 0xFF1E293B;
  static const int backgroundColorValue = 0xFFEFF6F9;
  static const int successColorValue = 0xFF10B981;
  static const int errorColorValue = 0xFFEF4444;
  static const int warningColorValue = 0xFFF59E0B;
  
  // Routes
  static const String splashRoute = '/';
  static const String loginRoute = '/login';
  static const String signupRoute = '/signup';
  static const String dashboardRoute = '/dashboard';
  static const String userDashboardRoute = '/user-dashboard';
  static const String adminDashboardRoute = '/admin-dashboard';
  static const String productDetailRoute = '/product-detail';
  static const String addProductRoute = '/add-product';
  static const String ordersRoute = '/orders';
  static const String productsRoute = '/products';
  
  // Assets
  static const String backgroundImage = 'assets/Background.jpg';
  static const String logoImage = 'assets/Logo.jpg';
  
  // Animation Durations (milliseconds)
  static const int splashDurationMs = 3500;
  static const int loadingDurationMs = 2000;
  static const int shortAnimationMs = 300;
  static const int mediumAnimationMs = 500;
  static const int longAnimationMs = 1000;
  
  // Validation Rules
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 128;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int minProductTitleLength = 3;
  static const int maxProductTitleLength = 100;
  static const int minDescriptionLength = 10;
  static const int maxDescriptionLength = 1000;
  
  // UI Constants
  static const double borderRadius = 12.0;
  static const double buttonBorderRadius = 24.0;
  static const double buttonHeight = 48.0;
  static const double cardPadding = 24.0;
  static const double sectionSpacing = 32.0;
  static const double itemSpacing = 16.0;
  static const double smallSpacing = 8.0;
  
  // Layout Breakpoints
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 1024.0;
  static const double desktopBreakpoint = 1440.0;
  
  // API & Database
  static const String usersCollection = 'users';
  static const String productsCollection = 'products';
  static const String ordersCollection = 'orders';
  
  // Default Values
  static const int defaultPageSize = 20;
  static const double defaultProductPrice = 0.0;
  static const String defaultProductCategory = 'Other';
  
  // Message Constants
  static const String defaultErrorMessage = 'Something went wrong. Please try again.';
  static const String networkErrorMessage = 'Please check your internet connection.';
  static const String loginSuccessMessage = 'Login successful!';
  static const String signupSuccessMessage = 'Account created successfully!';
  static const String logoutMessage = 'You have been logged out.';
}