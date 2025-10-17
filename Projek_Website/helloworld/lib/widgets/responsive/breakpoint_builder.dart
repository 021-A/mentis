import 'package:flutter/material.dart';
import '../../constants/breakpoints.dart';

/// Builder yang memberikan kontrol penuh berdasarkan breakpoint
class BreakpointBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, BoxConstraints constraints)? mobile;
  final Widget Function(BuildContext context, BoxConstraints constraints)? tablet;
  final Widget Function(BuildContext context, BoxConstraints constraints)? desktop;
  final Widget Function(BuildContext context, BoxConstraints constraints)? largeDesktop;
  final Widget Function(BuildContext context, BoxConstraints constraints) builder;

  const BreakpointBuilder({
    Key? key,
    this.mobile,
    this.tablet,
    this.desktop,
    this.largeDesktop,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= Breakpoints.largeDesktop && largeDesktop != null) {
          return largeDesktop!(context, constraints);
        } else if (constraints.maxWidth >= Breakpoints.desktop && desktop != null) {
          return desktop!(context, constraints);
        } else if (constraints.maxWidth >= Breakpoints.tablet && tablet != null) {
          return tablet!(context, constraints);
        } else if (mobile != null) {
          return mobile!(context, constraints);
        }
        return builder(context, constraints);
      },
    );
  }
}

/// Breakpoint Value Builder - untuk mendapatkan value berbeda per breakpoint
class BreakpointValue<T> {
  final T mobile;
  final T? tablet;
  final T? desktop;
  final T? largeDesktop;

  const BreakpointValue({
    required this.mobile,
    this.tablet,
    this.desktop,
    this.largeDesktop,
  });

  T getValue(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width >= Breakpoints.largeDesktop && largeDesktop != null) {
      return largeDesktop!;
    } else if (width >= Breakpoints.desktop && desktop != null) {
      return desktop!;
    } else if (width >= Breakpoints.tablet && tablet != null) {
      return tablet!;
    }
    return mobile;
  }
}

/// Custom Orientation Builder - berbeda untuk portrait/landscape
class CustomOrientationBuilder extends StatelessWidget {
  final Widget Function(BuildContext context) portrait;
  final Widget Function(BuildContext context)? landscape;

  const CustomOrientationBuilder({
    Key? key,
    required this.portrait,
    this.landscape,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    
    if (orientation == Orientation.landscape && landscape != null) {
      return landscape!(context);
    }
    return portrait(context);
  }
}

/// Combined Breakpoint & Orientation Builder
class ResponsiveOrientationBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, bool isPortrait, double width) builder;

  const ResponsiveOrientationBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
        return builder(context, isPortrait, constraints.maxWidth);
      },
    );
  }
}

/// Widget untuk menampilkan/hide berdasarkan breakpoint
class ResponsiveVisibility extends StatelessWidget {
  final Widget child;
  final bool visibleOnMobile;
  final bool visibleOnTablet;
  final bool visibleOnDesktop;
  final Widget? replacement;

  const ResponsiveVisibility({
    Key? key,
    required this.child,
    this.visibleOnMobile = true,
    this.visibleOnTablet = true,
    this.visibleOnDesktop = true,
    this.replacement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isVisible;
        
        if (constraints.maxWidth >= Breakpoints.desktop) {
          isVisible = visibleOnDesktop;
        } else if (constraints.maxWidth >= Breakpoints.tablet) {
          isVisible = visibleOnTablet;
        } else {
          isVisible = visibleOnMobile;
        }

        if (isVisible) {
          return child;
        } else {
          return replacement ?? const SizedBox.shrink();
        }
      },
    );
  }
}

/// Show only on specific device type
class ShowOnMobile extends StatelessWidget {
  final Widget child;
  final Widget? orElse;

  const ShowOnMobile({
    Key? key,
    required this.child,
    this.orElse,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveVisibility(
      visibleOnMobile: true,
      visibleOnTablet: false,
      visibleOnDesktop: false,
      replacement: orElse,
      child: child,
    );
  }
}

class ShowOnTablet extends StatelessWidget {
  final Widget child;
  final Widget? orElse;

  const ShowOnTablet({
    Key? key,
    required this.child,
    this.orElse,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveVisibility(
      visibleOnMobile: false,
      visibleOnTablet: true,
      visibleOnDesktop: false,
      replacement: orElse,
      child: child,
    );
  }
}

class ShowOnDesktop extends StatelessWidget {
  final Widget child;
  final Widget? orElse;

  const ShowOnDesktop({
    Key? key,
    required this.child,
    this.orElse,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveVisibility(
      visibleOnMobile: false,
      visibleOnTablet: false,
      visibleOnDesktop: true,
      replacement: orElse,
      child: child,
    );
  }
}

class HideOnMobile extends StatelessWidget {
  final Widget child;

  const HideOnMobile({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveVisibility(
      visibleOnMobile: false,
      visibleOnTablet: true,
      visibleOnDesktop: true,
      child: child,
    );
  }
}

class HideOnDesktop extends StatelessWidget {
  final Widget child;

  const HideOnDesktop({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveVisibility(
      visibleOnMobile: true,
      visibleOnTablet: true,
      visibleOnDesktop: false,
      child: child,
    );
  }
}
