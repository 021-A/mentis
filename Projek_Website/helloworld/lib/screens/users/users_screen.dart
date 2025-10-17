// lib/screens/users/users_screen.dart
// ignore_for_file: deprecated_member_use, avoid_init_to_null, duplicate_ignore, unused_local_variable

import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:helloworld/screens/analytics/analytics_screen.dart';
import 'package:intl/intl.dart';
import '../../extensions/responsive_extensions.dart';
import '../../utils/screen_size.dart';
import '../../constants/spacing.dart';
import '../../widgets/responsive_card.dart';

class UserEntry {
  String id;
  String name;
  String email;
  String role;
  String? avatarUrl;
  DateTime createdAt;
  bool isActive;
  int totalOrders;
  double totalSpent;

  UserEntry({
    required this.id,
    required this.name,
    required this.email,
    this.role = 'user',
    this.avatarUrl,
    DateTime? createdAt,
    this.isActive = true,
    this.totalOrders = 0,
    this.totalSpent = 0.0,
  }) : createdAt = createdAt ?? DateTime.now();
}

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _roleFilter = 'all';
  bool _isGridView = false;
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
        createdAt: DateTime.now().subtract(const Duration(days: 120)),
        totalOrders: 45,
        totalSpent: 15000000,
      ),
      UserEntry(
        id: 'u2',
        name: 'Siti Aminah',
        email: 'siti@example.com',
        role: 'user',
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
        totalOrders: 23,
        totalSpent: 8500000,
      ),
      UserEntry(
        id: 'u3',
        name: 'Budi Santoso',
        email: 'budi@example.com',
        role: 'user',
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        totalOrders: 5,
        totalSpent: 2100000,
      ),
      UserEntry(
        id: 'u4',
        name: 'Maya Putri',
        email: 'maya@example.com',
        role: 'user',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        totalOrders: 1,
        totalSpent: 450000,
        isActive: false,
      ),
      UserEntry(
        id: 'u5',
        name: 'Rudi Hermawan',
        email: 'rudi@example.com',
        role: 'user',
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        totalOrders: 32,
        totalSpent: 12000000,
      ),
    ]);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

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
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController(text: user?.name ?? '');
    final emailCtrl = TextEditingController(text: user?.email ?? '');
    String roleValue = user?.role ?? 'user';
    bool isActive = user?.isActive ?? true;

    showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(isEdit ? 'Edit User' : 'Add User'),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nameCtrl,
                        decoration: const InputDecoration(labelText: 'Name'),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Enter name' : null,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: emailCtrl,
                        decoration: const InputDecoration(labelText: 'Email'),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Enter email';
                          final pattern = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                          if (!pattern.hasMatch(v.trim())) {
                            return 'Enter valid email';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: roleValue,
                        decoration: const InputDecoration(labelText: 'Role'),
                        items: const [
                          DropdownMenuItem(value: 'user', child: Text('User')),
                          DropdownMenuItem(value: 'admin', child: Text('Admin')),
                        ],
                        onChanged: (v) {
                          setDialogState(() => roleValue = v ?? 'user');
                        },
                      ),
                      const SizedBox(height: 8),
                      SwitchListTile(
                        value: isActive,
                        title: const Text('Active account'),
                        onChanged: (v) {
                          setDialogState(() => isActive = v);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (!(formKey.currentState?.validate() ?? false)) return;
                    final name = nameCtrl.text.trim();
                    final email = emailCtrl.text.trim();

                    if (isEdit) {
                      setState(() {
                        user.name = name;
                        user.email = email;
                        user.role = roleValue;
                        user.isActive = isActive;
                      });
                      Navigator.of(dialogContext).pop(true);
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
                      Navigator.of(dialogContext).pop(true);
                    }
                  },
                  child: Text(isEdit ? 'Save' : 'Add'),
                ),
              ],
            );
          },
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
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() => _users.removeWhere((u) => u.id == user.id));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('User deleted'),
                  backgroundColor: Colors.redAccent,
                  behavior: SnackBarBehavior.floating,
                ),
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

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSize.of(context);
    final isDesktop = screenSize == ScreenSizeType.desktop;
    final isTablet = screenSize == ScreenSizeType.tablet;
    final filtered = _filteredUsers;

    var mobile = null;
    return Scaffold(
      body: Column(
        children: [
          // Header Section
          _buildHeader(isDesktop, isTablet),

          // Stats Summary
          _buildStatsSummary(isDesktop, isTablet),

          // Filters
          _buildFilters(),

          // User Count
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.responsivePadding),
            child: Row(
              children: [
                Text(
                  '${filtered.length} user(s)',
                  style: TextStyle(
                    fontSize: context.responsiveFontSize(14, mobile: mobile),
                    color: Colors.grey[600],
                  ),
                ),
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

          SizedBox(height: context.responsiveSpacing),

          // List
          Expanded(
            child: filtered.isEmpty
                ? _buildEmptyState()
                : (_isGridView && (isDesktop || isTablet))
                    ? _buildGridView(filtered, isDesktop, isTablet)
                    : _buildListView(filtered),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddEditDialog(),
        icon: const Icon(Icons.person_add),
        label: Text(isDesktop ? 'Add User' : 'Add'),
      ),
    );
  }

  Widget _buildHeader(bool isDesktop, bool isTablet) {
    var mobile = null;
    var mobile2 = null;
    return Container(
      padding: EdgeInsets.all(context.responsivePadding),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User Management',
                      style: TextStyle(
                        fontSize: context.responsiveFontSize(24, mobile: mobile),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: context.responsiveSmallSpacing / 2),
                    Text(
                      'Manage your platform users',
                      style: TextStyle(
                        fontSize: context.responsiveFontSize(14, mobile: mobile2),
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              if (isDesktop || isTablet)
                IconButton(
                  icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
                  onPressed: () => setState(() => _isGridView = !_isGridView),
                  tooltip: _isGridView ? 'List View' : 'Grid View',
                ),
            ],
          ),
          SizedBox(height: context.responsiveSpacing),
          // Search Bar
          TextField(
            controller: _searchCtrl,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Search by name or email...',
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
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSummary(bool isDesktop, bool isTablet) {
    final totalUsers = _users.length;
    final activeUsers = _users.where((u) => u.isActive).length;
    final adminUsers = _users.where((u) => u.role == 'admin').length;
    final totalRevenue = _users.fold<double>(0, (sum, u) => sum + u.totalSpent);

    final crossAxisCount = isDesktop ? 4 : (isTablet ? 2 : 2);

    return Padding(
      padding: EdgeInsets.all(context.responsivePadding),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: crossAxisCount,
        childAspectRatio: isDesktop ? 2.5 : 2,
        crossAxisSpacing: context.responsiveSmallSpacing,
        mainAxisSpacing: context.responsiveSmallSpacing,
        children: [
          _buildStatCard(
            'Total Users',
            totalUsers.toString(),
            Icons.people,
            Colors.blue,
          ),
          _buildStatCard(
            'Active Users',
            activeUsers.toString(),
            Icons.check_circle,
            Colors.green,
          ),
          _buildStatCard(
            'Admins',
            adminUsers.toString(),
            Icons.admin_panel_settings,
            Colors.orange,
          ),
          _buildStatCard(
            'Revenue',
            'Rp ${(totalRevenue / 1000000).toStringAsFixed(1)}M',
            Icons.attach_money,
            Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    var mobile = null;
    return ResponsiveCardM3(
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(context.responsiveSmallSpacing),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Icon(icon, color: color, size: context.responsiveIconSize(20)),
          ),
          SizedBox(width: context.responsiveSmallSpacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: context.responsiveFontSize(16, mobile: mobile),
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: context.responsiveFontSize(12, mobile: null),
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(
        vertical: context.responsiveSpacing,
        horizontal: context.responsivePadding,
      ),
      child: Row(
        children: [
          Text(
            'Filter:',
            style: TextStyle(
              fontSize: context.responsiveFontSize(14, mobile: null),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: context.responsiveSmallSpacing),
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterChip('All', 'all'),
                SizedBox(width: context.responsiveSmallSpacing / 2),
                _buildFilterChip('Admin', 'admin'),
                SizedBox(width: context.responsiveSmallSpacing / 2),
                _buildFilterChip('User', 'user'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _roleFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _roleFilter = value);
      },
      backgroundColor: Colors.grey[200],
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
      checkmarkColor: Theme.of(context).primaryColor,
      labelStyle: TextStyle(
        color: isSelected ? Theme.of(context).primaryColor : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  Widget _buildListView(List<UserEntry> users) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: context.responsivePadding,
        vertical: context.responsiveSmallSpacing,
      ),
      itemCount: users.length,
      itemBuilder: (context, index) => _buildUserCard(users[index]),
    );
  }

  Widget _buildGridView(List<UserEntry> users, bool isDesktop, bool isTablet) {
    final crossAxisCount = isDesktop ? 3 : 2;
    return GridView.builder(
      padding: EdgeInsets.all(context.responsivePadding),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: isDesktop ? 1.2 : 0.9,
        crossAxisSpacing: context.responsiveSpacing,
        mainAxisSpacing: context.responsiveSpacing,
      ),
      itemCount: users.length,
      itemBuilder: (context, index) => _buildUserGridCard(users[index]),
    );
  }

  Widget _buildUserCard(UserEntry user) {
    final createdStr = DateFormat.yMMMd().format(user.createdAt);
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return ResponsiveCardM3(
      margin: EdgeInsets.only(bottom: context.responsiveSpacing),
      child: ListTile(
        contentPadding: EdgeInsets.all(context.responsiveSmallSpacing),
        onTap: () => _openDetail(user),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: user.isActive ? Colors.blue.shade100 : Colors.grey.shade300,
          child: user.avatarUrl == null
              ? Text(
                  user.name.isEmpty
                      ? '?'
                      : user.name.split(' ').map((e) => e[0]).take(2).join(),
                  style: TextStyle(
                    color: user.isActive ? Colors.blue : Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: context.responsiveFontSize(16, mobile: null),
                  ),
                )
              : ClipOval(child: Image.network(user.avatarUrl!, fit: BoxFit.cover)),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                user.name,
                style: TextStyle(
                  fontSize: context.responsiveFontSize(16, mobile: null),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: user.role == 'admin'
                    // ignore: deprecated_member_use
                    ? Colors.orange.withOpacity(0.1)
                    // ignore: deprecated_member_use
                    : Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                user.role.toUpperCase(),
                style: TextStyle(
                  fontSize: context.responsiveFontSize(10, mobile: null),
                  color: user.role == 'admin' ? Colors.orange : Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: context.responsiveSmallSpacing / 2),
            if (!user.isActive)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'INACTIVE',
                  style: TextStyle(
                    fontSize: context.responsiveFontSize(10, mobile: null),
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: context.responsiveSmallSpacing / 2),
            Text(
              user.email,
              style: TextStyle(fontSize: context.responsiveFontSize(14, mobile: null)),
            ),
            SizedBox(height: context.responsiveSmallSpacing / 2),
            Row(
              children: [
                Icon(Icons.calendar_today,
                    size: context.responsiveIconSize(12), color: Colors.grey[600]),
                SizedBox(width: 4),
                Text(
                  createdStr,
                  style: TextStyle(
                    fontSize: context.responsiveFontSize(12, mobile: null),
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(width: context.responsiveSpacing),
                Icon(Icons.shopping_cart,
                    size: context.responsiveIconSize(12), color: Colors.grey[600]),
                SizedBox(width: 4),
                Text(
                  '${user.totalOrders} orders',
                  style: TextStyle(
                    fontSize: context.responsiveFontSize(12, mobile: null),
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            SizedBox(height: context.responsiveSmallSpacing / 2),
            Text(
              'Total: ${currencyFormat.format(user.totalSpent)}',
              style: TextStyle(
                fontSize: context.responsiveFontSize(13, mobile: null),
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
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

  Widget _buildUserGridCard(UserEntry user) {
    final createdStr = DateFormat.yMMMd().format(user.createdAt);
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    var mobile = null;
    return ResponsiveCardM3(
      onTap: () => _openDetail(user),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor:
                    user.isActive ? Colors.blue.shade100 : Colors.grey.shade300,
                child: user.avatarUrl == null
                    ? Text(
                        user.name.isEmpty
                            ? '?'
                            : user.name.split(' ').map((e) => e[0]).take(2).join(),
                        style: TextStyle(
                          color: user.isActive ? Colors.blue : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : ClipOval(
                        child: Image.network(user.avatarUrl!, fit: BoxFit.cover)),
              ),
              const Spacer(),
              PopupMenuButton<int>(
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
            ],
          ),
          SizedBox(height: context.responsiveSmallSpacing),
          Text(
            user.name,
            style: TextStyle(
              fontSize: context.responsiveFontSize(16, mobile: null),
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            user.email,
            style: TextStyle(
              fontSize: context.responsiveFontSize(12, mobile: null),
              color: Colors.grey[600],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: context.responsiveSmallSpacing),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: user.role == 'admin'
                      // ignore: deprecated_member_use
                      ? Colors.orange.withOpacity(0.1)
                      // ignore: deprecated_member_use
                      : Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  user.role.toUpperCase(),
                  style: TextStyle(
                    fontSize: context.responsiveFontSize(10, mobile: null),
                    color: user.role == 'admin' ? Colors.orange : Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (!user.isActive) ...[
                SizedBox(width: context.responsiveSmallSpacing / 2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'INACTIVE',
                    style: TextStyle(
                      fontSize: context.responsiveFontSize(10, mobile: null),
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: context.responsiveSmallSpacing),
          Divider(height: 1),
          SizedBox(height: context.responsiveSmallSpacing),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    user.totalOrders.toString(),
                    style: TextStyle(
                      fontSize: context.responsiveFontSize(16, mobile: null),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Orders',
                    style: TextStyle(
                      fontSize: context.responsiveFontSize(11, mobile: null),
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              Container(width: 1, height: 30, color: Colors.grey[300]),
              Column(
                children: [
                  Text(
                    'Rp ${(user.totalSpent / 1000000).toStringAsFixed(1)}M',
                    style: TextStyle(
                      fontSize: context.responsiveFontSize(14, mobile: null),
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Text(
                    'Spent',
                    style: TextStyle(
                      fontSize: context.responsiveFontSize(11, mobile: mobile),
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _searchCtrl.text.isNotEmpty
                ? Icons.search_off
                : Icons.people_outline,
            size: context.responsiveIconSize(80),
            color: Colors.grey[400],
          ),
          SizedBox(height: context.responsiveSpacing),
          Text(
            _searchCtrl.text.isNotEmpty ? 'No users found' : 'No users yet',
            style: TextStyle(
              fontSize: context.responsiveFontSize(18, mobile: null),
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: context.responsiveSmallSpacing),
          Text(
            _searchCtrl.text.isNotEmpty
                ? 'Try different search terms'
                : 'Add your first user to get started',
            style: TextStyle(
              fontSize: context.responsiveFontSize(14, mobile: null),
              color: Colors.grey[500],
            ),
          ),
          if (_searchCtrl.text.isEmpty) ...[
            SizedBox(height: context.responsiveLargeSpacing),
            ElevatedButton.icon(
              onPressed: () => _openAddEditDialog(),
              icon: const Icon(Icons.person_add),
              label: const Text('Add User'),
            ),
          ],
        ],
      ),
    );
  }
}

class UserDetailScreen extends StatelessWidget {
  final UserEntry user;

  const UserDetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final created = DateFormat.yMMMd().add_Hm().format(user.createdAt);
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('User Detail')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.responsivePadding),
        child: Column(
          children: [
            CircleAvatar(
              radius: 44,
              backgroundColor: Colors.blueGrey.shade100,
              child: user.avatarUrl == null
                  ? Text(
                      user.name.split(' ').map((e) => e[0]).take(2).join(),
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    )
                  : ClipOval(
                      child: Image.network(user.avatarUrl!, fit: BoxFit.cover)),
            ),
            SizedBox(height: context.responsiveSpacing),
            Text(
              user.name,
              style: TextStyle(
                fontSize: context.responsiveFontSize(24, mobile: null),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: context.responsiveSmallSpacing / 2),
            Text(
              user.email,
              style: TextStyle(
                fontSize: context.responsiveFontSize(14, mobile: null),
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: context.responsiveSpacing),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Chip(label: Text(user.role.toUpperCase())),
                SizedBox(width: context.responsiveSmallSpacing),
                Chip(label: Text(user.isActive ? 'Active' : 'Disabled')),
              ],
            ),
            SizedBox(height: context.responsiveLargeSpacing),
            ResponsiveCardM3(
              child: Column(
                children: [
                  _buildDetailRow(context, Icons.calendar_today, 'Created at', created),
                  Divider(height: context.responsiveSpacing * 2),
                  _buildDetailRow(
                    context,
                    Icons.shopping_cart,
                    'Total Orders',
                    user.totalOrders.toString(),
                  ),
                  Divider(height: context.responsiveSpacing * 2),
                  _buildDetailRow(
                    context,
                    Icons.attach_money,
                    'Total Spent',
                    currencyFormat.format(user.totalSpent),
                  ),
                ],
              ),
            ),
            SizedBox(height: context.responsiveLargeSpacing),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
      BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: context.responsiveIconSize(20), color: Colors.grey[600]),
        SizedBox(width: context.responsiveSpacing),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: context.responsiveFontSize(12, mobile: null),
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: context.responsiveFontSize(16, mobile: null),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}