// lib/extensions/context_extensions.dart
import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  // Screen dimensions
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  double get statusBarHeight => MediaQuery.of(this).padding.top;
  double get bottomBarHeight => MediaQuery.of(this).padding.bottom;
  
  // Device type checks
  bool get isSmallScreen => screenWidth < 600;
  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 1024;
  bool get isDesktop => screenWidth >= 1024;
  bool get isLargeDesktop => screenWidth >= 1440;
  
  // Orientation
  bool get isPortrait => MediaQuery.of(this).orientation == Orientation.portrait;
  bool get isLandscape => MediaQuery.of(this).orientation == Orientation.landscape;
  
  // Theme shortcuts
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;
  Color get primaryColor => colorScheme.primary;
  Color get backgroundColor => theme.scaffoldBackgroundColor;
  
  // Text styles shortcuts
  TextStyle? get headlineLarge => textTheme.headlineLarge;
  TextStyle? get headlineMedium => textTheme.headlineMedium;
  TextStyle? get headlineSmall => textTheme.headlineSmall;
  TextStyle? get titleLarge => textTheme.titleLarge;
  TextStyle? get titleMedium => textTheme.titleMedium;
  TextStyle? get titleSmall => textTheme.titleSmall;
  TextStyle? get bodyLarge => textTheme.bodyLarge;
  TextStyle? get bodyMedium => textTheme.bodyMedium;
  TextStyle? get bodySmall => textTheme.bodySmall;
  
  // Navigation shortcuts
  void pushNamed(String routeName, {Object? arguments}) {
    Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }
  
  void pushReplacementNamed(String routeName, {Object? arguments}) {
    Navigator.of(this).pushReplacementNamed(routeName, arguments: arguments);
  }
  
  void pushNamedAndRemoveUntil(String routeName, {Object? arguments}) {
    Navigator.of(this).pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }
  
  void pop([Object? result]) {
    Navigator.of(this).pop(result);
  }
  
  void popUntil(String routeName) {
    Navigator.of(this).popUntil(ModalRoute.withName(routeName));
  }
  
  bool canPop() {
    return Navigator.of(this).canPop();
  }
  
  // Snackbar shortcuts
  void showSnackbar(
    String message, {
    Color? backgroundColor,
    Color? textColor,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: textColor ?? Colors.white),
        ),
        backgroundColor: backgroundColor,
        duration: duration,
        action: action,
      ),
    );
  }
  
  void showSuccessSnackbar(String message) {
    showSnackbar(
      message,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }
  
  void showErrorSnackbar(String message) {
    showSnackbar(
      message,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }
  
  void showWarningSnackbar(String message) {
    showSnackbar(
      message,
      backgroundColor: Colors.orange,
      textColor: Colors.white,
    );
  }
  
  // Dialog shortcuts
  Future<bool?> showConfirmDialog({
    required String title,
    required String content,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Color? confirmColor,
  }) async {
    return showDialog<bool>(
      context: this,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: confirmColor != null
                ? ElevatedButton.styleFrom(backgroundColor: confirmColor)
                : null,
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }
  
  Future<void> showInfoDialog({
    required String title,
    required String content,
    String buttonText = 'OK',
  }) async {
    return showDialog<void>(
      context: this,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
  
  // Loading dialog
  void showLoadingDialog({String message = 'Loading...'}) {
    showDialog(
      context: this,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 20),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }
  
  void hideLoadingDialog() {
    if (canPop()) {
      pop();
    }
  }
  
  // Keyboard
  void hideKeyboard() {
    FocusScope.of(this).unfocus();
  }
  
  bool get isKeyboardVisible {
    return MediaQuery.of(this).viewInsets.bottom > 0;
  }
  
  // Safe area
  EdgeInsets get safeAreaPadding => MediaQuery.of(this).padding;
  double get safeAreaTop => MediaQuery.of(this).padding.top;
  double get safeAreaBottom => MediaQuery.of(this).padding.bottom;
}