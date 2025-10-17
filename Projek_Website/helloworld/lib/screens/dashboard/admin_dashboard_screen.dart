// lib/screens/dashboard/admin_dashboard_screen.dart
// ignore_for_file: use_build_context_synchronously, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:helloworld/screens/dashboard/admin_profile_screen.dart' show AdminProfileScreen;
import 'package:helloworld/screens/analytics/analytics_screen.dart';
import 'package:helloworld/screens/orders/orders_screen.dart';
import 'package:helloworld/screens/products/products_screen.dart' as products_screen;
import 'package:helloworld/screens/users/users_screen.dart';
import 'package:helloworld/services/auth_service.dart';
import 'package:helloworld/services/product_service.dart';
import 'package:helloworld/widgets/stat_card.dart';
import '../../extensions/responsive_extensions.dart';
import '../../utils/screen_size.dart';
import '../../widgets/responsive/adaptive_scaffold.dart';
import '../../widgets/responsive_card.dart' show ResponsiveCardM3;

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;
  final AuthService _authService = AuthService();
  
  // Stats data
  int _totalProducts = 0;
  int _totalOrders = 0;
  int _totalUsers = 0;
  double _totalRevenue = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);
    
    try {
      final products = await ProductService.getAllProducts(); // async corrected
      setState(() {
        _totalProducts = products.length;
        _totalOrders = 156; // Example, replace with OrderService
        _totalUsers = 234; // Example, replace with UserService
        _totalRevenue = 125000000.0;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e')),
        );
      }
    }
  }

  List<Widget> _buildScreens() {
    final screenSize = ScreenSize.of(context);
    final isMobile = screenSize.isMobile;

    return [
      _buildDashboardHome(),
      const products_screen.ProductsScreen(),
      const OrdersScreen(),
      const UsersScreen(),
      AnalyticsScreen(mobile: isMobile),
      const AdminProfileScreen(),
    ];
  }

  Widget _buildDashboardHome() {
    final screenSize = ScreenSize.of(context);
    final isDesktop = screenSize.isDesktop;
    final isTablet = screenSize.isTablet;

    return RefreshIndicator(
      onRefresh: _loadDashboardData,
      child: SingleChildScrollView(
        padding: context.responsivePadding,
        child: _buildDashboardContent(isDesktop, isTablet),
      ),
    );
  }

  Widget _buildDashboardContent(bool isDesktop, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildWelcomeHeader(),
        SizedBox(height: context.responsiveSpacing),
        _buildStatsGrid(isDesktop, isTablet),
        SizedBox(height: context.responsiveLargeSpacing),
        if (isDesktop || isTablet) ...[
          _buildQuickActionsSection(),
          SizedBox(height: context.responsiveLargeSpacing),
        ],
        _buildRecentActivitySection(),
      ],
    );
  }

  Widget _buildWelcomeHeader() {
    final screenSize = ScreenSize.of(context);
    final isMobile = screenSize.isMobile;

    return ResponsiveCardM3(
      mobile: isMobile,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome Back, Admin!',
                  style: TextStyle(
                    fontSize: context.responsiveFontSize(24),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: context.responsiveSmallSpacing),
                Text(
                  'Here\'s what\'s happening with your store today',
                  style: TextStyle(
                    fontSize: context.responsiveFontSize(14),
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          if (!isMobile)
            Icon(
              Icons.admin_panel_settings,
              size: context.responsiveIconSize(48),
              color: Theme.of(context).primaryColor,
            ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(bool isDesktop, bool isTablet) {
    final crossAxisCount = isDesktop ? 4 : (isTablet ? 2 : 1);
    final childAspectRatio = isDesktop ? 1.5 : (isTablet ? 1.8 : 2.5);
    final isMobile = ScreenSize.of(context).isMobile;

    if (_isLoading) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
          crossAxisSpacing: context.responsiveSpacing,
          mainAxisSpacing: context.responsiveSpacing,
        ),
        itemCount: 4,
        itemBuilder: (context, index) => _buildLoadingStat(),
      );
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      childAspectRatio: childAspectRatio,
      crossAxisSpacing: context.responsiveSpacing,
      mainAxisSpacing: context.responsiveSpacing,
      children: [
        StatCard(
          title: 'Total Products',
          value: _totalProducts.toString(),
          icon: Icons.inventory_2,
          color: Colors.blue,
          mobile: isMobile,
        ),
        StatCard(
          title: 'Total Orders',
          value: _totalOrders.toString(),
          icon: Icons.shopping_cart,
          color: Colors.green,
          mobile: isMobile,
        ),
        StatCard(
          title: 'Total Users',
          value: _totalUsers.toString(),
          icon: Icons.people,
          color: Colors.orange,
          mobile: isMobile,
        ),
        StatCard(
          title: 'Revenue',
          value: 'Rp ${(_totalRevenue / 1000000).toStringAsFixed(1)}M',
          icon: Icons.attach_money,
          color: Colors.purple,
          mobile: isMobile,
        ),
      ],
    );
  }

  Widget _buildLoadingStat() {
    final isMobile = ScreenSize.of(context).isMobile;
    return ResponsiveCardM3(
      mobile: isMobile,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: context.responsiveFontSize(20),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: context.responsiveSpacing),
        Wrap(
          spacing: context.responsiveSpacing,
          runSpacing: context.responsiveSpacing,
          children: [
            _buildQuickActionCard(
              'Add Product',
              Icons.add_shopping_cart,
              Colors.blue,
              () => _navigateToTab(1),
            ),
            _buildQuickActionCard(
              'View Orders',
              Icons.list_alt,
              Colors.green,
              () => _navigateToTab(2),
            ),
            _buildQuickActionCard(
              'Manage Users',
              Icons.person_add,
              Colors.orange,
              () => _navigateToTab(3),
            ),
            _buildQuickActionCard(
              'Analytics',
              Icons.analytics,
              Colors.purple,
              () => _navigateToTab(4),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    final screenSize = ScreenSize.of(context);
    final isDesktop = screenSize.isDesktop;
    final isMobile = screenSize.isMobile;
    final maxWidth = isDesktop ? 200.0 : 160.0;

    return SizedBox(
      width: maxWidth,
      child: ResponsiveCardM3(
        mobile: isMobile,
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(context.responsiveSpacing),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: context.responsiveIconSize(32),
              ),
            ),
            SizedBox(height: context.responsiveSmallSpacing),
            Text(
              title,
              style: TextStyle(
                fontSize: context.responsiveFontSize(14),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivitySection() {
    final isMobile = ScreenSize.of(context).isMobile;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: TextStyle(
            fontSize: context.responsiveFontSize(20),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: context.responsiveSpacing),
        ResponsiveCardM3(
          mobile: isMobile,
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            separatorBuilder: (context, index) => Divider(
              height: context.responsiveSpacing * 2,
            ),
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.primaries[index % Colors.primaries.length].withOpacity(0.1),
                  child: Icon(
                    _getActivityIcon(index),
                    color: Colors.primaries[index % Colors.primaries.length],
                    size: context.responsiveIconSize(20),
                  ),
                ),
                title: Text(
                  _getActivityTitle(index),
                  style: TextStyle(fontSize: context.responsiveFontSize(14)),
                ),
                subtitle: Text(
                  _getActivityTime(index),
                  style: TextStyle(fontSize: context.responsiveFontSize(12)),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: context.responsiveIconSize(16),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  IconData _getActivityIcon(int index) {
    const icons = [
      Icons.shopping_bag,
      Icons.person_add,
      Icons.inventory_2,
      Icons.star,
      Icons.chat,
    ];
    return icons[index % icons.length];
  }

  String _getActivityTitle(int index) {
    const titles = [
      'New order #1234 received',
      'New user registered',
      'Product "Laptop Gaming" added',
      '5 new reviews received',
      'Customer message received',
    ];
    return titles[index % titles.length];
  }

  String _getActivityTime(int index) {
    const times = [
      '2 minutes ago',
      '15 minutes ago',
      '1 hour ago',
      '3 hours ago',
      'Yesterday',
    ];
    return times[index % times.length];
  }

  void _navigateToTab(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final screens = _buildScreens();
    
    return AdaptiveScaffold(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) => setState(() => _selectedIndex = index),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        NavigationDestination(
          icon: Icon(Icons.inventory_2_outlined),
          selectedIcon: Icon(Icons.inventory_2),
          label: 'Products',
        ),
        NavigationDestination(
          icon: Icon(Icons.shopping_cart_outlined),
          selectedIcon: Icon(Icons.shopping_cart),
          label: 'Orders',
        ),
        NavigationDestination(
          icon: Icon(Icons.people_outline),
          selectedIcon: Icon(Icons.people),
          label: 'Users',
        ),
        NavigationDestination(
          icon: Icon(Icons.analytics_outlined),
          selectedIcon: Icon(Icons.analytics),
          label: 'Analytics',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      body: screens[_selectedIndex],
      appBarTitle: _getAppBarTitle(),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: _handleLogout,
        ),
      ],
    );
  }

  String _getAppBarTitle() {
    const titles = [
      'Admin Dashboard',
      'Products Management',
      'Orders Management',
      'Users Management',
      'Analytics',
      'Admin Profile',
    ];
    return titles[_selectedIndex];
  }

  Future<void> _handleLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout == true && mounted) {
      await _authService.signOut();
      if (mounted) Navigator.of(context).pushReplacementNamed('/login');
    }
  }
}
