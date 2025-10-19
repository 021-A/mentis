// lib/screens/users/users_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Simple local user model for this screen (self-contained).
/// Jika kamu punya `models/user.dart`, kamu bisa mengganti penggunaan
/// UserEntry dengan model project-mu.
class UserEntry {
  String id;
  String name;
  String email;
  String role; // e.g. 'admin' or 'user'
  String? avatarUrl;
  DateTime createdAt;
  bool isActive;

  UserEntry({
    required this.id,
    required this.name,
    required this.email,
    this.role = 'user',
    this.avatarUrl,
    DateTime? createdAt,
    this.isActive = true,
  }) : createdAt = createdAt ?? DateTime.now();
}

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  // --- state & controllers ---
  final TextEditingController _searchCtrl = TextEditingController();
  String _roleFilter = 'all'; // 'all' | 'admin' | 'user'
  final List<UserEntry> _users = [];

  @override
  void initState() {
    super.initState();
    _initDummyUsers();
  }

  void _initDummyUsers() {
    _users.addAll([
      UserEntry(
        id: 'u1',
        name: 'Dedi Firmansyah',
        email: 'dedi@example.com',
        role: 'admin',
        avatarUrl: null,
        createdAt: DateTime.now().subtract(const Duration(days: 120)),
      ),
      UserEntry(
        id: 'u2',
        name: 'Siti Aminah',
        email: 'siti@example.com',
        role: 'user',
        avatarUrl: null,
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
      ),
      UserEntry(
        id: 'u3',
        name: 'Budi Santoso',
        email: 'budi@example.com',
        role: 'user',
        avatarUrl: null,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
    ]);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  // --- helpers ---
  List<UserEntry> get _filteredUsers {
    final q = _searchCtrl.text.trim().toLowerCase();
    return _users.where((u) {
      final matchRole = _roleFilter == 'all' || u.role == _roleFilter;
      final matchQuery = q.isEmpty ||
          u.name.toLowerCase().contains(q) ||
          u.email.toLowerCase().contains(q);
      return matchRole && matchQuery;
    }).toList();
  }

  void _openAddEditDialog({UserEntry? user}) {
    final isEdit = user != null;
    // ignore: no_leading_underscores_for_local_identifiers
    final _formKey = GlobalKey<FormState>();
    final TextEditingController nameCtrl = TextEditingController(text: user?.name ?? '');
    final TextEditingController emailCtrl = TextEditingController(text: user?.email ?? '');
    String roleValue = user?.role ?? 'user';
    bool isActive = user?.isActive ?? true;

    showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEdit ? 'Edit User' : 'Add User'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter name' : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: emailCtrl,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Enter email';
                      final pattern = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                      if (!pattern.hasMatch(v.trim())) return 'Enter valid email';
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    // ignore: deprecated_member_use
                    value: roleValue,
                    decoration: const InputDecoration(labelText: 'Role'),
                    items: const [
                      DropdownMenuItem(value: 'user', child: Text('User')),
                      DropdownMenuItem(value: 'admin', child: Text('Admin')),
                    ],
                    onChanged: (v) => roleValue = v ?? 'user',
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    value: isActive,
                    title: const Text('Active account'),
                    onChanged: (v) {
                      isActive = v;
                      // rebuild dialog to show state change
                      (context as Element).markNeedsBuild();
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (!(_formKey.currentState?.validate() ?? false)) return;
                final name = nameCtrl.text.trim();
                final email = emailCtrl.text.trim();

                if (isEdit) {
                  // update existing
                  setState(() {
                    user.name = name;
                    user.email = email;
                    user.role = roleValue;
                    user.isActive = isActive;
                  });
                  Navigator.of(context).pop(true);
                } else {
                  final newUser = UserEntry(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: name,
                    email: email,
                    role: roleValue,
                    createdAt: DateTime.now(),
                    isActive: isActive,
                  );
                  setState(() => _users.insert(0, newUser));
                  Navigator.of(context).pop(true);
                }
              },
              child: Text(isEdit ? 'Save' : 'Add'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmation(UserEntry user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete user'),
        content: Text('Are you sure you want to delete "${user.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() => _users.removeWhere((u) => u.id == user.id));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('User deleted'), backgroundColor: Colors.redAccent),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _openDetail(UserEntry user) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) => UserDetailScreen(user: user)),
    );
  }

  Widget _buildUserTile(UserEntry user) {
    final createdStr = DateFormat.yMMMd().format(user.createdAt);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: () => _openDetail(user),
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: Colors.blueGrey.shade100,
          child: user.avatarUrl == null
              ? Text(
                  user.name.isEmpty ? '?' : user.name.split(' ').map((e) => e[0]).take(2).join(),
                  style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                )
              : ClipOval(child: Image.network(user.avatarUrl!, fit: BoxFit.cover)),
        ),
        title: Text(user.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.email),
            const SizedBox(height: 4),
            Text('$createdStr • Role: ${user.role} • ${user.isActive ? "Active" : "Disabled"}',
                style: const TextStyle(fontSize: 12)),
          ],
        ),
        isThreeLine: true,
        trailing: PopupMenuButton<int>(
          onSelected: (v) {
            if (v == 0) _openDetail(user);
            if (v == 1) _openAddEditDialog(user: user);
            if (v == 2) _showDeleteConfirmation(user);
          },
          itemBuilder: (ctx) => const [
            PopupMenuItem(value: 0, child: Text('View')),
            PopupMenuItem(value: 1, child: Text('Edit')),
            PopupMenuItem(value: 2, child: Text('Delete')),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredUsers;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Users'),
        actions: [
          IconButton(
            tooltip: 'Add user',
            onPressed: () => _openAddEditDialog(),
            icon: const Icon(Icons.person_add),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filters
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchCtrl,
                    decoration: InputDecoration(
                      hintText: 'Search by name or email',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchCtrl.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchCtrl.clear();
                                setState(() {});
                              },
                            )
                          : null,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 12),
                PopupMenuButton<String>(
                  tooltip: 'Filter role',
                  onSelected: (v) {
                    setState(() => _roleFilter = v);
                  },
                  itemBuilder: (ctx) => const [
                    PopupMenuItem(value: 'all', child: Text('All roles')),
                    PopupMenuItem(value: 'admin', child: Text('Admin')),
                    PopupMenuItem(value: 'user', child: Text('User')),
                  ],
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _roleFilter == 'all'
                              ? Icons.filter_list
                              : (_roleFilter == 'admin' ? Icons.admin_panel_settings : Icons.person),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(_roleFilter == 'all' ? 'All' : (_roleFilter == 'admin' ? 'Admin' : 'User')),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Count & empty state
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Text('${filtered.length} user(s)'),
                const Spacer(),
                if (_searchCtrl.text.isNotEmpty || _roleFilter != 'all')
                  TextButton(
                    onPressed: () {
                      _searchCtrl.clear();
                      setState(() => _roleFilter = 'all');
                    },
                    child: const Text('Reset filters'),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 6),

          // List
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.people_outline, size: 56, color: Colors.grey),
                        const SizedBox(height: 8),
                        const Text('No users found', style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => _openAddEditDialog(),
                          child: const Text('Add first user'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 12),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) => _buildUserTile(filtered[index]),
                  ),
          ),
        ],
      ),
    );
  }
}

/// Simple detail screen for a user
class UserDetailScreen extends StatelessWidget {
  final UserEntry user;

  const UserDetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final created = DateFormat.yMMMd().add_Hm().format(user.createdAt);
    return Scaffold(
      appBar: AppBar(title: const Text('User Detail')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 44,
              backgroundColor: Colors.blueGrey.shade100,
              child: user.avatarUrl == null
                  ? Text(
                      user.name.split(' ').map((e) => e[0]).take(2).join(),
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    )
                  : ClipOval(child: Image.network(user.avatarUrl!, fit: BoxFit.cover)),
            ),
            const SizedBox(height: 12),
            Text(user.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(user.email),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Chip(label: Text(user.role.toUpperCase())),
                const SizedBox(width: 8),
                Chip(label: Text(user.isActive ? 'Active' : 'Disabled')),
              ],
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Created at'),
              subtitle: Text(created),
            ),
            // add more info if needed
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Back'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
