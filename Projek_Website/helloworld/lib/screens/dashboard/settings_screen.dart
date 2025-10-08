// lib/screens/dashboard/settings_screen.dart
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../auth/login_screen.dart';

// Navigasi ke screen terpisah
import '../auth/change_password_screen.dart';
import 'language_settings_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthService _authService = AuthService();
  String _languageLabel = 'System default';

  Future<void> _logout() async {
    await _authService.signOut();

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  // buka change password screen dan tunggu hasil (true = sukses)
  Future<void> _openChangePassword() async {
    final result = await Navigator.push<bool?>(
      context,
      MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
    );

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password berhasil diubah.')),
      );
    }
  }

  // buka language settings dan terima hasil (value string)
  Future<void> _openLanguageSettings() async {
    final result = await Navigator.push<String?>(
      context,
      MaterialPageRoute(builder: (_) => const LanguageSettingsScreen()),
    );

    if (result != null && mounted) {
      setState(() {
        _languageLabel = result == 'en'
            ? 'English'
            : result == 'id'
                ? 'Bahasa Indonesia'
                : 'System default';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bahasa diubah menjadi: $_languageLabel')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text("Change Password"),
            subtitle: const Text("Update your account password"),
            onTap: _openChangePassword,
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text("Language"),
            subtitle: Text(_languageLabel),
            onTap: _openLanguageSettings,
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout"),
            onTap: _logout,
          ),
        ],
      ),
    );
  }
}
