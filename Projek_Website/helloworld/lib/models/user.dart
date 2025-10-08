// lib/models/user.dart
class User {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.createdAt,
  });

  // 🔹 Konversi dari Map/JSON ke User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      role: json['role'] == 'admin' ? UserRole.admin : UserRole.user,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // 🔹 Konversi User ke Map/JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role == UserRole.admin ? 'admin' : 'user',
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

enum UserRole { user, admin }
