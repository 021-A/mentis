// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../models/user.dart';
import '../../widgets/password_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService();
  
  bool _isLoading = false;
  UserRole _selectedRole = UserRole.user;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final user = await _authService.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
        role: _selectedRole,
      );

      if (user != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Account created successfully! Please login.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("❌ Sign up failed: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
            
            // Calculate available height and optimal container height
            double availableHeight = constraints.maxHeight - (isDesktop ? 48 : 32);
            double containerHeight = isDesktop 
                ? (availableHeight > 600 ? 600 : availableHeight) 
                : availableHeight;
            
            return Center(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.all(isDesktop ? 24 : 16),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: isDesktop ? containerHeight : 0,
                  ),
                  child: Container(
                    width: isDesktop ? 900 : (isTablet ? 700 : double.infinity),
                    height: containerHeight,
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
        Expanded(child: _buildSignupForm()),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0D9488), Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: const Center(
              child: Padding(
                padding: EdgeInsets.only(left: 32, right: 48),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "JOIN OUR\nCOMMUNITY!",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.05,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Create your account and start\nyour learning journey with us today",
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
      ],
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: _buildSignupForm(),
    );
  }

  Widget _buildSignupForm() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 24, 40, 24),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
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
                    child: const Icon(Icons.person_add_alt_1, size: 32, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "MENTIS",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0D9488)),
                  ),
                  const Text("Create Account", style: TextStyle(fontSize: 16, color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Name
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person_outline),
                labelText: "Full Name",
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
                if (value == null || value.isEmpty) {
                  return "Name tidak boleh kosong";
                }
                if (value.length < 2) {
                  return "Name minimal 2 karakter";
                }
                return null;
              },
            ),
            const SizedBox(height: 12),

            // Email
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
                if (value == null || value.isEmpty) {
                  return "Email tidak boleh kosong";
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return "Masukkan email yang valid";
                }
                return null;
              },
            ),
            const SizedBox(height: 12),

            // Role
            DropdownButtonFormField<UserRole>(
              value: _selectedRole,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.badge_outlined),
                labelText: "Role",
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
              items: const [
                DropdownMenuItem(
                  value: UserRole.user,
                  child: Text("User"),
                ),
                DropdownMenuItem(
                  value: UserRole.admin,
                  child: Text("Admin"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedRole = value!;
                });
              },
            ),
            const SizedBox(height: 12),

            // Password
            PasswordField(
              controller: _passwordController,
              labelText: "Password",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Password tidak boleh kosong";
                }
                if (value.length < 6) {
                  return "Password minimal 6 karakter";
                }
                return null;
              },
            ),
            const SizedBox(height: 12),

            // Confirm Password
            PasswordField(
              controller: _confirmPasswordController,
              labelText: "Confirm Password",
              prefixIcon: Icons.lock_person_outlined,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Konfirmasi password tidak boleh kosong";
                }
                if (value != _passwordController.text) {
                  return "Password tidak cocok";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Sign Up button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleSignup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D9488),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: _isLoading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text("SIGN UP", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 14),

            // Login link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account? "),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D9488),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
