// lib/screens/auth/login_screen.dart - VERSI PERBAIKAN
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import '../../services/auth_service.dart';
import '../../models/user.dart';
import '../../widgets/password_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    User? user;
    String? errorMessage;

    try {
      user = await _authService.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    } catch (e) {
      developer.log('Login error: $e', name: 'login_screen');
      errorMessage = _getErrorMessage(e.toString());
    }

    if (!mounted) return;

    // Handle login result
    if (user != null) {
      developer.log('Login successful: ${user.email}, Role: ${user.role}', name: 'login_screen');

      if (user.role == UserRole.admin) {
        Navigator.pushReplacementNamed(context, '/admin-dashboard');
      } else {
        Navigator.pushReplacementNamed(context, '/user-dashboard');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage ?? 'Login failed. Please check your credentials.'),
          backgroundColor: Colors.red,
        ),
      );
    }

    // Stop loading
    if (mounted) setState(() => _isLoading = false);
  }

  String _getErrorMessage(String error) {
    if (error.contains('USER_NOT_FOUND')) {
      return 'Pengguna dengan email ini tidak ditemukan.';
    } else if (error.contains('WRONG_PASSWORD')) {
      return 'Password yang dimasukkan salah.';
    } else if (error.contains('EMAIL_ALREADY_IN_USE')) {
      return 'Email sudah terdaftar.';
    }
    return 'Login gagal. Silakan coba lagi.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF0D9488).withAlpha(180),
              const Color(0xFF1E293B).withAlpha(200),
            ],
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isDesktop = constraints.maxWidth > 800;
            bool isTablet = constraints.maxWidth > 600 && constraints.maxWidth <= 800;
            
            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(isDesktop ? 24 : 16),
                child: Container(
                  width: isDesktop ? 800 : (isTablet ? 600 : double.infinity),
                  height: isDesktop ? 520 : null,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(30),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0D9488), Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            child: const Center(
              child: Padding(
                padding: EdgeInsets.only(left: 48, right: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "WELCOME\nBACK!",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.05,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Login with your credentials and\ncontinue your journey with us",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(child: _buildLoginForm()),
      ],
    );
  }

  Widget _buildMobileLayout() => _buildLoginForm();

  Widget _buildLoginForm() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 32, 32, 32),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      color: const Color(0xFF0D9488),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withAlpha(77),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.school, size: 32, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "MENTIS",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0D9488)),
                  ),
                  const Text("Welcome Back", style: TextStyle(fontSize: 16, color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email_outlined),
                labelText: "Email",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF0D9488)),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return "Email tidak boleh kosong";
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return "Masukkan email yang valid";
                return null;
              },
            ),
            const SizedBox(height: 16),
            PasswordField(
              controller: _passwordController,
              labelText: "Password",
              validator: (value) {
                if (value == null || value.isEmpty) return "Password tidak boleh kosong";
                if (value.length < 6) return "Password minimal 6 karakter";
                return null;
              },
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _showForgotPasswordDialog,
                child: const Text("Forgot Password?", style: TextStyle(color: Color(0xFF0D9488))),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D9488),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: _isLoading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text("LOGIN", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account? "),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/signup'),
                  child: const Text("Sign Up", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0D9488))),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showForgotPasswordDialog() {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Masukkan email Anda untuk menerima instruksi reset password.'),
            const SizedBox(height: 16),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              final email = emailController.text.trim();
              if (email.isEmpty) return;
              
              Navigator.of(context).pop();

              try {
                await _authService.resetPassword(email);

                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Email reset password telah dikirim!'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D9488)),
            child: const Text('Kirim', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}