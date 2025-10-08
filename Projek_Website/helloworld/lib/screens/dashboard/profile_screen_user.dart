// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6F9),
      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: const Color(0xFF0D9488),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/Logo.jpg'),
            ),
            const SizedBox(height: 16),
            const Text(
              "Dedi Firmansyah",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const Text(
              "dedi.firmansyah@example.com",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),

            // Info Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: const [
                  ListTile(
                    leading: Icon(Icons.person_outline, color: Color(0xFF0D9488)),
                    title: Text("Full Name"),
                    subtitle: Text("Dedi Firmansyah"),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.email_outlined, color: Color(0xFF0D9488)),
                    title: Text("Email"),
                    subtitle: Text("dedi.firmansyah@example.com"),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.phone_android, color: Color(0xFF0D9488)),
                    title: Text("Phone"),
                    subtitle: Text("+62 812 3456 7890"),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.school_outlined, color: Color(0xFF0D9488)),
                    title: Text("Role"),
                    subtitle: Text("Student / User"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Edit Profile Button
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Edit profile coming soon...")),
                );
              },
              icon: const Icon(Icons.edit),
              label: const Text("Edit Profile"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D9488),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
