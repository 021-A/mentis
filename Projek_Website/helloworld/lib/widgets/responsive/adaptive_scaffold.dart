import 'package:flutter/material.dart';
import '../../utils/screen_size.dart';

class AdaptiveScaffold extends StatelessWidget {
  final String? title;
  final Widget body;
  final Widget? drawer;
  final Widget? endDrawer;
  final List<Widget>? actions;
  final FloatingActionButton? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool showDrawerOnMobile;
  final bool showNavigationRail;
  
  const AdaptiveScaffold({
    Key? key,
    this.title,
    required this.body,
    this.drawer,
    this.endDrawer,
    this.actions,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.showDrawerOnMobile = true,
    this.showNavigationRail = true, required int selectedIndex, required Null Function(dynamic index) onDestinationSelected, required List<NavigationDestination> destinations, required String appBarTitle,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final screen = ScreenSize(context);
    
    // Desktop: Show navigation rail
    if (screen.isDesktop && showNavigationRail && drawer != null) {
      return Scaffold(
        appBar: _buildAppBar(context, showMenuButton: false),
        body: Row(
          children: [
            _buildNavigationRail(context),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(screen.responsive(
                  mobile: 16,
                  tablet: 24,
                  desktop: 32,
                )),
                child: body,
              ),
            ),
          ],
        ),
        floatingActionButton: floatingActionButton,
      );
    }
    
    // Tablet & Mobile: Traditional drawer
    return Scaffold(
      appBar: _buildAppBar(context, showMenuButton: showDrawerOnMobile),
      drawer: showDrawerOnMobile ? drawer : null,
      endDrawer: endDrawer,
      body: Padding(
        padding: EdgeInsets.all(screen.responsive(
          mobile: 16,
          tablet: 20,
          desktop: 24,
        )),
        child: body,
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
  
  PreferredSizeWidget? _buildAppBar(BuildContext context, {required bool showMenuButton}) {
    if (title == null && actions == null) return null;
    
    return AppBar(
      title: title != null ? Text(title!) : null,
      automaticallyImplyLeading: showMenuButton,
      actions: actions,
    );
  }
  
  Widget _buildNavigationRail(BuildContext context) {
    // Implementasi navigation rail untuk desktop
    // Anda bisa customize sesuai kebutuhan
    return Container(
      width: 80,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: drawer ?? const SizedBox(),
    );
  }
}