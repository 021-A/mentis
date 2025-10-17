import 'package:flutter/material.dart';
import '../../utils/screen_size.dart';

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ScreenSize screen) builder;
  
  const ResponsiveBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return builder(context, ScreenSize(context));
  }
}