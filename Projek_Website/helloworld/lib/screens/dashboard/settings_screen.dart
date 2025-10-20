// lib/screens/dashboard/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/auth_service.dart';
import '../auth/login_screen.dart';
import '../auth/change_password_screen.dart';
import 'language_settings_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthService _authService = AuthService();
  
  // ✨ NEW: Settings state
  bool _darkMode = false;
  bool _notifications = true;
  bool _emailNotifications = true;
  String _languageLabel = 'System default';
  String _currentUser = 'Loading...';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  /// ✨ NEW: Load all settings from SharedPreferences
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final user = await _authService.getCurrentUser();
      
      setState(() {
        _darkMode = prefs.getBool('darkMode') ?? false;
        _notifications = prefs.getBool('notifications') ?? true;
        _emailNotifications = prefs.getBool('emailNotifications') ?? true;
        _languageLabel = prefs.getString('language') ?? 'System default';
        _currentUser = user?.email ?? 'Unknown';
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  /// ✨ NEW: Save dark mode preference
  Future<void> _toggleDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
    
    setState(() => _darkMode = value);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(value 
              ? '🌙 Dark mode enabled (restart required)'
              : '☀️ Light mode enabled (restart required)'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  /// ✨ NEW: Save notification preference
  Future<void> _toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', value);
    
    setState(() => _notifications = value);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(value 
              ? '🔔 Notifications enabled'
              : '🔕 Notifications disabled'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  /// ✨ NEW: Save email notification preference
  Future<void> _toggleEmailNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('emailNotifications', value);
    
    setState(() => _emailNotifications = value);
  }

  /// ✨ ENHANCED: Logout with confirmation
  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _authService.signOut();

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  /// Open change password screen
  Future<void> _openChangePassword() async {
    final result = await Navigator.push<bool?>(
      context,
      MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
    );

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Password berhasil diubah.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  /// ✨ ENHANCED: Open language settings with save
  Future<void> _openLanguageSettings() async {
    final result = await Navigator.push<String?>(
      context,
      MaterialPageRoute(builder: (_) => const LanguageSettingsScreen()),
    );

    if (result != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language', result);
      
      setState(() {
        _languageLabel = result == 'en'
            ? 'English'
            : result == 'id'
                ? 'Bahasa Indonesia'
                : 'System default';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🌐 Bahasa diubah menjadi: $_languageLabel'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // ✨ NEW: User Profile Section
                _buildSectionHeader('Account', Icons.person_outline),
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFF0D9488),
                          child: Text(
                            _currentUser[0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: const Text('Signed in as'),
                        subtitle: Text(
                          _currentUser,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF0D9488),
                          ),
                        ),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.lock_outline),
                        title: const Text("Change Password"),
                        subtitle: const Text("Update your account password"),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: _openChangePassword,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ✨ NEW: Appearance Section
                _buildSectionHeader('Appearance', Icons.palette_outlined),
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      SwitchListTile(
                        secondary: Icon(
                          _darkMode ? Icons.dark_mode : Icons.light_mode,
                          color: _darkMode ? Colors.indigo : Colors.amber,
                        ),
                        title: const Text("Dark Mode"),
                        subtitle: Text(_darkMode 
                            ? "Dark theme enabled" 
                            : "Light theme enabled"),
                        value: _darkMode,
                        onChanged: _toggleDarkMode,
                        activeThumbColor: const Color(0xFF0D9488),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.language),
                        title: const Text("Language"),
                        subtitle: Text(_languageLabel),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: _openLanguageSettings,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ✨ NEW: Notifications Section
                _buildSectionHeader('Notifications', Icons.notifications_outlined),
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      SwitchListTile(
                        secondary: Icon(
                          _notifications 
                              ? Icons.notifications_active 
                              : Icons.notifications_off,
                          color: _notifications 
                              ? const Color(0xFF0D9488) 
                              : Colors.grey,
                        ),
                        title: const Text("Push Notifications"),
                        subtitle: Text(_notifications 
                            ? "Receive app notifications" 
                            : "Notifications disabled"),
                        value: _notifications,
                        onChanged: _toggleNotifications,
                        activeThumbColor: const Color(0xFF0D9488),
                      ),
                      const Divider(height: 1),
                      SwitchListTile(
                        secondary: Icon(
                          _emailNotifications ? Icons.email : Icons.email_outlined,
                          color: _emailNotifications 
                              ? const Color(0xFF0D9488) 
                              : Colors.grey,
                        ),
                        title: const Text("Email Notifications"),
                        subtitle: Text(_emailNotifications 
                            ? "Receive email updates" 
                            : "Email notifications disabled"),
                        value: _emailNotifications,
                        onChanged: _toggleEmailNotifications,
                        activeThumbColor: const Color(0xFF0D9488),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ✨ NEW: About Section
                _buildSectionHeader('About', Icons.info_outline),
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.description_outlined),
                        title: const Text("Terms & Conditions"),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // TODO: Navigate to Terms screen
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Coming soon...')),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.privacy_tip_outlined),
                        title: const Text("Privacy Policy"),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // TODO: Navigate to Privacy screen
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Coming soon...')),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      const ListTile(
                        leading: Icon(Icons.info_outlined),
                        title: Text("App Version"),
                        subtitle: Text("MENTIS v1.0.0"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ✨ ENHANCED: Logout Button
                Card(
                  elevation: 1,
                  color: Colors.red[50],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: const Text("Sign out from your account"),
                    onTap: _logout,
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
    );
  }

  /// ✨ NEW: Section header widget
  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}