// lib/services/auth_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user.dart';

class AuthService {
  // 🔹 Keys untuk SharedPreferences
  static const String _registeredUsersKey = 'registered_users';
  static const String _currentUserKey = 'current_user_id';
  static const String _rememberMeKey = 'remember_me';
  static const String _lastLoginKey = 'last_login_time';

  // 🔹 Hardcoded credentials (dummy users)
  static const Map<String, Map<String, dynamic>> _hardcodedUsers = {
    'admin@test.com': {
      'password': '123456',
      'id': 'admin_001',
      'name': 'Admin User',
      'email': 'admin@test.com',
      'role': 'admin',
      'createdAt': '2024-01-01T00:00:00.000Z'
    },
    'user@test.com': {
      'password': '123456',
      'id': 'user_001',
      'name': 'Regular User',
      'email': 'user@test.com',
      'role': 'user',
      'createdAt': '2024-01-01T00:00:00.000Z'
    }
  };

  // 🔹 Sign up
  Future<User?> signUp({
    required String email,
    required String password,
    required String name,
    UserRole role = UserRole.user,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final existingUsers = prefs.getStringList(_registeredUsersKey) ?? [];

    if (existingUsers.contains(email)) {
      throw Exception('EMAIL_ALREADY_IN_USE');
    }

    final user = User(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      name: name,
      role: role,
      createdAt: DateTime.now(),
    );

    await prefs.setString('user_${user.id}', jsonEncode({
      'id': user.id,
      'email': user.email,
      'name': user.name,
      'role': role == UserRole.admin ? 'admin' : 'user',
      'password': password,
      'createdAt': user.createdAt.toIso8601String(),
    }));

    existingUsers.add(email);
    await prefs.setStringList(_registeredUsersKey, existingUsers);

    // Auto-login after signup
    await _saveLoginState(user.id, remember: true);

    return user;
  }

  // 🔹 Sign in (ENHANCED dengan remember me)
  Future<User?> signIn({
    required String email,
    required String password,
    bool rememberMe = true,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // Cek hardcoded users
    if (_hardcodedUsers.containsKey(email)) {
      final userData = _hardcodedUsers[email]!;
      if (userData['password'] == password) {
        final user = User(
          id: userData['id'],
          email: userData['email'],
          name: userData['name'],
          role: userData['role'] == 'admin' ? UserRole.admin : UserRole.user,
          createdAt: DateTime.parse(userData['createdAt']),
        );
        await _saveLoginState(user.id, remember: rememberMe);
        return user;
      } else {
        throw Exception('WRONG_PASSWORD');
      }
    }

    // Cek registered users
    final registeredUsers = prefs.getStringList(_registeredUsersKey) ?? [];
    if (!registeredUsers.contains(email)) {
      throw Exception('USER_NOT_FOUND');
    }

    for (String key in prefs.getKeys()) {
      if (key.startsWith('user_')) {
        final userJson = prefs.getString(key);
        if (userJson != null) {
          final userData = jsonDecode(userJson);
          if (userData['email'] == email) {
            if (userData['password'] == password) {
              final user = User(
                id: userData['id'],
                email: userData['email'],
                name: userData['name'],
                role: userData['role'] == 'admin' ? UserRole.admin : UserRole.user,
                createdAt: DateTime.parse(userData['createdAt']),
              );
              await _saveLoginState(user.id, remember: rememberMe);
              return user;
            } else {
              throw Exception('WRONG_PASSWORD');
            }
          }
        }
      }
    }

    throw Exception('USER_NOT_FOUND');
  }

  // 🔹 Get user data
  Future<User?> getUserData(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Cek hardcoded users dulu
    for (var userData in _hardcodedUsers.values) {
      if (userData['id'] == uid) {
        return User(
          id: userData['id'],
          email: userData['email'],
          name: userData['name'],
          role: userData['role'] == 'admin' ? UserRole.admin : UserRole.user,
          createdAt: DateTime.parse(userData['createdAt']),
        );
      }
    }
    
    // Cek registered users
    final userJson = prefs.getString('user_$uid');
    if (userJson != null) {
      final userData = jsonDecode(userJson);
      return User(
        id: userData['id'],
        email: userData['email'],
        name: userData['name'],
        role: userData['role'] == 'admin' ? UserRole.admin : UserRole.user,
        createdAt: DateTime.parse(userData['createdAt']),
      );
    }
    return null;
  }

  // 🔹 Sign out
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
    await prefs.remove(_rememberMeKey);
    await prefs.remove(_lastLoginKey);
  }

  // 🔹 Reset password (simulasi)
  Future<void> resetPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    // hanya simulasi, tidak ada pengiriman email
  }

  // 🔹 Check login status
  Future<bool> get isLoggedIn async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(_currentUserKey);
    final rememberMe = prefs.getBool(_rememberMeKey) ?? false;
    
    if (userId != null && rememberMe) {
      // Check jika login masih valid (contoh: 30 hari)
      final lastLogin = prefs.getString(_lastLoginKey);
      if (lastLogin != null) {
        final lastLoginDate = DateTime.parse(lastLogin);
        final daysSinceLogin = DateTime.now().difference(lastLoginDate).inDays;
        
        if (daysSinceLogin > 30) {
          // Auto logout jika sudah lebih dari 30 hari
          await signOut();
          return false;
        }
      }
      return true;
    }
    
    return false;
  }

  // 🔹 Get current user
  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(_currentUserKey);
    if (userId != null) {
      return await getUserData(userId);
    }
    return null;
  }

  // 🔹 Get current user role
  Future<UserRole?> getUserRole() async {
    final user = await getCurrentUser();
    return user?.role;
  }

  // 🔹 Change password (ENHANCED)
  Future<void> changePassword(String currentPassword, String newPassword) async {
    final user = await getCurrentUser();
    if (user == null) {
      throw Exception('USER_NOT_LOGGED_IN');
    }

    final prefs = await SharedPreferences.getInstance();
    
    // Cek hardcoded users (tidak bisa ganti password)
    if (_hardcodedUsers.containsKey(user.email)) {
      throw Exception('CANNOT_CHANGE_HARDCODED_USER_PASSWORD');
    }

    // Cek registered users
    final userJson = prefs.getString('user_${user.id}');
    if (userJson != null) {
      final userData = jsonDecode(userJson);
      
      // Verify current password
      if (userData['password'] != currentPassword) {
        throw Exception('WRONG_CURRENT_PASSWORD');
      }

      // Update password
      userData['password'] = newPassword;
      await prefs.setString('user_${user.id}', jsonEncode(userData));
    } else {
      throw Exception('USER_NOT_FOUND');
    }
  }

  // 🔹 PRIVATE: Save login state
  Future<void> _saveLoginState(String userId, {required bool remember}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserKey, userId);
    await prefs.setBool(_rememberMeKey, remember);
    await prefs.setString(_lastLoginKey, DateTime.now().toIso8601String());
  }

  // ✨ NEW: Get last login time
  Future<DateTime?> getLastLoginTime() async {
    final prefs = await SharedPreferences.getInstance();
    final lastLogin = prefs.getString(_lastLoginKey);
    if (lastLogin != null) {
      return DateTime.parse(lastLogin);
    }
    return null;
  }

  // ✨ NEW: Check if remember me is enabled
  Future<bool> isRememberMeEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_rememberMeKey) ?? false;
  }

  // ✨ NEW: Get all registered users (for admin)
  Future<List<User>> getAllUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final List<User> users = [];

    // Add hardcoded users
    for (var userData in _hardcodedUsers.values) {
      users.add(User(
        id: userData['id'],
        email: userData['email'],
        name: userData['name'],
        role: userData['role'] == 'admin' ? UserRole.admin : UserRole.user,
        createdAt: DateTime.parse(userData['createdAt']),
      ));
    }

    // Add registered users
    for (String key in prefs.getKeys()) {
      if (key.startsWith('user_')) {
        final userJson = prefs.getString(key);
        if (userJson != null) {
          final userData = jsonDecode(userJson);
          users.add(User(
            id: userData['id'],
            email: userData['email'],
            name: userData['name'],
            role: userData['role'] == 'admin' ? UserRole.admin : UserRole.user,
            createdAt: DateTime.parse(userData['createdAt']),
          ));
        }
      }
    }

    return users;
  }

  // ✨ NEW: Delete user (for admin)
  Future<void> deleteUser(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Tidak bisa hapus hardcoded users
    for (var userData in _hardcodedUsers.values) {
      if (userData['id'] == userId) {
        throw Exception('CANNOT_DELETE_HARDCODED_USER');
      }
    }

    // Hapus user data
    await prefs.remove('user_$userId');
    
    // Update registered users list
    final userJson = prefs.getString('user_$userId');
    if (userJson != null) {
      final userData = jsonDecode(userJson);
      final registeredUsers = prefs.getStringList(_registeredUsersKey) ?? [];
      registeredUsers.remove(userData['email']);
      await prefs.setStringList(_registeredUsersKey, registeredUsers);
    }
  }
}