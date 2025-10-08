// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_loading.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkUserRole();
  }

  Future<void> _checkUserRole() async {
    final isLoggedIn = await _authService.isLoggedIn;
    if (!mounted) return;

    if (isLoggedIn) {
      final role = await _authService.getUserRole();

      if (role == UserRole.admin) {
        Navigator.pushReplacementNamed(context, '/admin-dashboard');
      } else if (role == UserRole.user) {
        Navigator.pushReplacementNamed(context, '/user-dashboard');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const FullScreenLoading(
      message: "Preparing your dashboard...",
      showLogo: true,
    );
  }
}

class UserRole {
  static Object? get admin => null;
  
  static Object? get user => null;
}