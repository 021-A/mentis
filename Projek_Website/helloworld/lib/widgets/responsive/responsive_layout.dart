import 'package:flutter/material.dart';
import '../../constants/breakpoints.dart';

/// Widget untuk membuat layout yang berbeda untuk mobile, tablet, dan desktop
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const ResponsiveLayout({
    Key? key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= Breakpoints.desktop) {
          return desktop;
        } else if (constraints.maxWidth >= Breakpoints.tablet) {
          return tablet ?? mobile;
        } else {
          return mobile;
        }
      },
    );
  }
}

/// Widget untuk membuat layout dengan sidebar yang adaptif
class ResponsiveLayoutWithSidebar extends StatelessWidget {
  final Widget body;
  final Widget sidebar;
  final double sidebarWidth;
  final bool showSidebarOnMobile;

  const ResponsiveLayoutWithSidebar({
    Key? key,
    required this.body,
    required this.sidebar,
    this.sidebarWidth = 250,
    this.showSidebarOnMobile = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= Breakpoints.desktop;
        
        if (isDesktop) {
          // Desktop: Show sidebar permanently
          return Row(
            children: [
              SizedBox(
                width: sidebarWidth,
                child: sidebar,
              ),
              Expanded(child: body),
            ],
          );
        } else if (showSidebarOnMobile) {
          // Mobile/Tablet: Show sidebar as drawer
          return body;
        } else {
          // Mobile/Tablet: No sidebar
          return body;
        }
      },
    );
  }
}

/// Widget untuk center content dengan max width
class ResponsiveCenterContent extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsets? padding;

  const ResponsiveCenterContent({
    Key? key,
    required this.child,
    this.maxWidth = 1200,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }
}

/// Responsive Grid View dengan auto columns
class ResponsiveGridView extends StatelessWidget {
  final List<Widget> children;
  final double minItemWidth;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const ResponsiveGridView({
    Key? key,
    required this.children,
    this.minItemWidth = 250,
    this.mainAxisSpacing = 16,
    this.crossAxisSpacing = 16,
    this.childAspectRatio = 1.0,
    this.shrinkWrap = false,
    this.physics,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = (constraints.maxWidth / minItemWidth).floor();
        final actualColumns = columns < 1 ? 1 : columns;

        return GridView.count(
          crossAxisCount: actualColumns,
          mainAxisSpacing: mainAxisSpacing,
          crossAxisSpacing: crossAxisSpacing,
          childAspectRatio: childAspectRatio,
          shrinkWrap: shrinkWrap,
          physics: physics,
          children: children,
        );
      },
    );
  }
}

/// Responsive Wrap dengan spacing otomatis
class ResponsiveWrap extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final WrapAlignment alignment;
  final WrapCrossAlignment crossAlignment;

  const ResponsiveWrap({
    Key? key,
    required this.children,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
    this.alignment = WrapAlignment.start,
    this.crossAlignment = WrapCrossAlignment.start,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= Breakpoints.desktop;
        final isTablet = constraints.maxWidth >= Breakpoints.tablet;

        final actualSpacing = isDesktop ? spacing * 1.5 : 
                             isTablet ? spacing * 1.2 : 
                             spacing;

        return Wrap(
          spacing: actualSpacing,
          runSpacing: actualSpacing,
          alignment: alignment,
          crossAxisAlignment: crossAlignment,
          children: children,
        );
      },
    );
  }
}

/// Two Column Layout yang responsive
class ResponsiveTwoColumnLayout extends StatelessWidget {
  final Widget leftColumn;
  final Widget rightColumn;
  final double breakpoint;
  final double leftFlex;
  final double rightFlex;
  final double spacing;

  const ResponsiveTwoColumnLayout({
    Key? key,
    required this.leftColumn,
    required this.rightColumn,
    this.breakpoint = Breakpoints.tablet,
    this.leftFlex = 1,
    this.rightFlex = 1,
    this.spacing = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= breakpoint) {
          // Desktop/Tablet: Two columns side by side
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: leftFlex.toInt(),
                child: leftColumn,
              ),
              SizedBox(width: spacing),
              Expanded(
                flex: rightFlex.toInt(),
                child: rightColumn,
              ),
            ],
          );
        } else {
          // Mobile: Stack vertically
          return Column(
            children: [
              leftColumn,
              SizedBox(height: spacing),
              rightColumn,
            ],
          );
        }
      },
    );
  }
}