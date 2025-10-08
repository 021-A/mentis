// lib/services/auth_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user.dart';

class AuthService {
  // 🔹 Keys untuk SharedPreferences
  static const String _registeredUsersKey = 'registered_users';
  static const String _currentUserKey = 'current_user_id';

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

    return user;
  }

  // 🔹 Sign in
  Future<User?> signIn({
    required String email,
    required String password,
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
        await prefs.setString(_currentUserKey, user.id);
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
              await prefs.setString(_currentUserKey, user.id);
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
  }

  // 🔹 Reset password (simulasi)
  Future<void> resetPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    // hanya simulasi, tidak ada pengiriman email
  }

  // 🔹 Check login status
  Future<bool> get isLoggedIn async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentUserKey) != null;
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

  Future<void> changePassword(String current, String newPw) async {}
}
