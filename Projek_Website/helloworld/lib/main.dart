// lib/main.dart
import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/dashboard/user_dashboard_screen.dart';
import 'screens/dashboard/admin_dashboard_screen.dart';
import 'screens/products/add_product_screen.dart';
import 'screens/products/products_screen.dart';
import 'screens/orders/orders_screen.dart';
import 'screens/users/users_screen.dart';
import 'screens/analytics/analytics_screen.dart';
import 'screens/dashboard/settings_screen.dart';
import 'screens/detail/product_detail_screen.dart';

// Import model agar kita bisa memeriksa tipe argument saat routing
import 'models/product.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MentisApp());
}

class MentisApp extends StatelessWidget {
  const MentisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MENTIS - Digital Learning Platform',
      theme: ThemeData(
        fontFamily: "Poppins",
        primaryColor: const Color(0xFF0D9488),
        scaffoldBackgroundColor: const Color(0xFFEFF6F9),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal)
            .copyWith(secondary: const Color(0xFF1E293B)),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0D9488),
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            minimumSize: const Size(double.infinity, 48),
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF0D9488), width: 1.8),
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0D9488),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/user-dashboard': (context) => const UserDashboardScreen(),
        '/admin-dashboard': (context) => const AdminDashboardScreen(),
        '/add_product': (context) => const AddProductScreen(),
        '/products': (context) => const ProductsScreen(),
        '/orders': (context) => const OrdersScreen(),
        '/users': (context) => const UsersScreen(),
        '/analytics': (context) => const AnalyticsScreen(),
        '/settings': (context) => const SettingsScreen(),
      },

      // Handle routes that need runtime arguments
      onGenerateRoute: (settings) {
        if (settings.name == '/product-detail') {
          final args = settings.arguments;
          if (args is BaseProduct) {
            return MaterialPageRoute(
              builder: (_) => ProductDetailScreen(product: args, productId: '',),
            );
          } else {
            return MaterialPageRoute(
              builder: (_) => Scaffold(
                appBar: AppBar(title: const Text('Product')),
                body: const Center(child: Text('Product data not provided.')),
              ),
            );
          }
        }
        return null; // unknown route
      },
    );
  }
}
