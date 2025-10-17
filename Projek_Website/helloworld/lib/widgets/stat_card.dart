// lib/widgets/stat_card.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../extensions/responsive_extensions.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;
  final String? trend;
  final bool isPositiveTrend;
  final VoidCallback? onTap;
  final bool showTrendIcon;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
    this.trend,
    this.isPositiveTrend = true,
    this.onTap,
    this.showTrendIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    final screen = context.screen;
    
    return Card(
      elevation: screen.responsive(
        mobile: 2,
        tablet: 2,
        desktop: 3,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          screen.responsive(mobile: 12, tablet: 14, desktop: 16),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          screen.responsive(mobile: 12, tablet: 14, desktop: 16),
        ),
        child: Container(
          padding: EdgeInsets.all(
            screen.responsive(mobile: 16, tablet: 18, desktop: 20),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              screen.responsive(mobile: 12, tablet: 14, desktop: 16),
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                color.withOpacity(0.02),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    icon,
                    color: color,
                    size: screen.responsive(
                      mobile: 20,
                      tablet: 22,
                      desktop: 24,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(
                      screen.responsive(mobile: 6, tablet: 7, desktop: 8),
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: screen.responsive(
                        mobile: 14,
                        tablet: 15,
                        desktop: 16,
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(
                height: screen.responsive(mobile: 12, tablet: 14, desktop: 16),
              ),
              
              // Value
              Text(
                value,
                style: TextStyle(
                  fontSize: screen.responsive(
                    mobile: 22,
                    tablet: 26,
                    desktop: 28,
                  ),
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              
              SizedBox(
                height: screen.responsive(mobile: 6, tablet: 7, desktop: 8),
              ),
              
              // Title
              Text(
                title,
                style: TextStyle(
                  fontSize: screen.responsive(
                    mobile: 13,
                    tablet: 13.5,
                    desktop: 14,
                  ),
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              // Subtitle and Trend
              if (subtitle != null || trend != null) ...[
                SizedBox(
                  height: screen.responsive(mobile: 6, tablet: 7, desktop: 8),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (subtitle != null)
                      Expanded(
                        child: Text(
                          subtitle!,
                          style: TextStyle(
                            fontSize: screen.responsive(
                              mobile: 11,
                              tablet: 11.5,
                              desktop: 12,
                            ),
                            color: Colors.grey.shade500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    if (trend != null)
                      Row(
                        children: [
                          if (showTrendIcon)
                            Icon(
                              isPositiveTrend
                                  ? Icons.trending_up
                                  : Icons.trending_down,
                              size: screen.responsive(
                                mobile: 14,
                                tablet: 15,
                                desktop: 16,
                              ),
                              color: isPositiveTrend
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          if (showTrendIcon) const SizedBox(width: 4),
                          Text(
                            trend!,
                            style: TextStyle(
                              fontSize: screen.responsive(
                                mobile: 11,
                                tablet: 11.5,
                                desktop: 12,
                              ),
                              fontWeight: FontWeight.w600,
                              color: isPositiveTrend
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// Variant untuk StatCard yang lebih compact (Responsive)
class CompactStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const CompactStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screen = context.screen;
    
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          screen.responsive(mobile: 8, tablet: 10, desktop: 12),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          screen.responsive(mobile: 8, tablet: 10, desktop: 12),
        ),
        child: Padding(
          padding: EdgeInsets.all(
            screen.responsive(mobile: 12, tablet: 14, desktop: 16),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(
                  screen.responsive(mobile: 10, tablet: 11, desktop: 12),
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: screen.responsive(
                    mobile: 18,
                    tablet: 19,
                    desktop: 20,
                  ),
                ),
              ),
              SizedBox(
                width: screen.responsive(mobile: 12, tablet: 14, desktop: 16),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: screen.responsive(
                          mobile: 18,
                          tablet: 19,
                          desktop: 20,
                        ),
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: screen.responsive(mobile: 3, tablet: 3.5, desktop: 4),
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: screen.responsive(
                          mobile: 13,
                          tablet: 13.5,
                          desktop: 14,
                        ),
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Variant untuk StatCard Horizontal (Desktop optimized)
class HorizontalStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const HorizontalStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screen = context.screen;
    
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screen.responsive(mobile: 16, tablet: 20, desktop: 24),
            vertical: screen.responsive(mobile: 12, tablet: 14, desktop: 16),
          ),
          child: Row(
            children: [
              // Icon Container
              Container(
                padding: EdgeInsets.all(
                  screen.responsive(mobile: 12, tablet: 14, desktop: 16),
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: screen.responsive(
                    mobile: 24,
                    tablet: 28,
                    desktop: 32,
                  ),
                ),
              ),
              SizedBox(
                width: screen.responsive(mobile: 16, tablet: 20, desktop: 24),
              ),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: screen.responsive(
                          mobile: 13,
                          tablet: 14,
                          desktop: 14,
                        ),
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: screen.responsive(mobile: 4, tablet: 6, desktop: 8),
                    ),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: screen.responsive(
                          mobile: 20,
                          tablet: 24,
                          desktop: 28,
                        ),
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}