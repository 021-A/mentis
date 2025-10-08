// lib/widgets/custom_loading.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class CustomLoadingIndicator extends StatefulWidget {
  final double size;
  final Color? color;
  final double strokeWidth;

  const CustomLoadingIndicator({
    super.key,
    this.size = 20,
    this.color,
    this.strokeWidth = 2,
  });

  @override
  State<CustomLoadingIndicator> createState() => _CustomLoadingIndicatorState();
}

class _CustomLoadingIndicatorState extends State<CustomLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: CircularProgressIndicator(
        strokeWidth: widget.strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(
          widget.color ?? Colors.white,
        ),
      ),
    );
  }
}

class FullScreenLoading extends StatelessWidget {
  final String message;
  final bool showLogo;

  const FullScreenLoading({
    super.key,
    this.message = "Loading...",
    this.showLogo = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D9488).withOpacity(0.9),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showLogo) ...[
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.asset(
                    'assets/Logo.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: const Icon(
                          Icons.school,
                          size: 40,
                          color: Color(0xFF0D9488),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'MENTIS',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 30),
            ],
            const CustomLoadingIndicator(
              size: 40,
              color: Colors.white,
              strokeWidth: 3,
            ),
            const SizedBox(height: 20),
            Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
