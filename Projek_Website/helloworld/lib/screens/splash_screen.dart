// lib/screens/splash_screen.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
    ));

    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 1.0, curve: Curves.linear),
    ));

    _startAnimation();
  }

  void _startAnimation() {
    _animationController.forward();
    
    Timer(const Duration(milliseconds: 6000), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF0D9488).withOpacity(0.8),
                const Color(0xFF1E293B).withOpacity(0.9),
              ],
            ),
          ),
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo with animations
                    Transform.scale(
                      scale: _scaleAnimation.value,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: Image.asset(
                              'assets/Logo.jpg',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(60),
                                  ),
                                  child: const Icon(
                                    Icons.school,
                                    size: 60,
                                    color: Color(0xFF0D9488),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // App Name
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: const Text(
                        'MENTIS',
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 8,
                          shadows: [
                            Shadow(
                              offset: Offset(2, 2),
                              blurRadius: 8,
                              color: Colors.black26,
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 10),
                    
                    // Tagline
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: const Text(
                        'Digital Learning Platform',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 60),
                    
                    // Loading indicator with rotation
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Transform.rotate(
                        angle: _rotateAnimation.value * 6.28, // 2π for full rotation
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: _buildRotatingElement(),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 100),
                    
                    // Creator name
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: const Text(
                        'Created by\nDedi Firmansyah',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white60,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // CSS-inspired rotating element converted to Flutter
  Widget _buildRotatingElement() {
    return Container(
      width: 32,
      height: 32,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFFCFCFC),
        shape: BoxShape.circle,
        boxShadow: [
          // Inset shadows simulated with multiple containers
          BoxShadow(
            color: Colors.white.withOpacity(0.6),
            offset: const Offset(0, -3),
            blurRadius: 4,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            offset: const Offset(0, -4),
            blurRadius: 8,
          ),
          BoxShadow(
            color: const Color(0xFF787775),
            offset: const Offset(0, -9),
            blurRadius: 12,
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            center: const Alignment(-0.3, -0.3),
            colors: [
              Colors.white.withValues(alpha: 0.8),
              const Color(0xFF787775).withValues(alpha: 0.6),
              const Color(0xFF787775),
            ],
            stops: const [0.0, 0.7, 1.0],
          ),
        ),
      ),
    );
  }
}