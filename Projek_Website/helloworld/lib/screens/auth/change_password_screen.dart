// lib/screens/auth/change_password_screen.dart
// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final current = _currentCtrl.text.trim();
    final newPw = _newCtrl.text.trim();

    setState(() => _isLoading = true);
    try {
      // Sesuaikan nama method dengan AuthService mu:
      // contoh: changePassword(currentPassword, newPassword)
      await _authService.changePassword(current, newPw);

      if (mounted) {
        // Beri tahu screen pemanggil bahwa perubahan sukses
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengubah password: ${e.toString()}')),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Change Password')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _currentCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Current password'),
                validator: (v) => (v == null || v.isEmpty) ? 'Masukkan password saat ini' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _newCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'New password'),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Masukkan password baru';
                  if (v.length < 6) return 'Minimal 6 karakter';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _confirmCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Confirm new password'),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Konfirmasi password';
                  if (v != _newCtrl.text) return 'Password tidak cocok';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
