// lib/utils/formatters.dart
import 'package:intl/intl.dart';

/// Utility class untuk format currency, date, dan number
class AppFormatters {
  // ===== CURRENCY FORMATTING =====
  
  /// Format currency dalam Rupiah (Rp 25.000)
  static String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  /// Format currency dalam Dollar ($25.00)
  static String formatCurrencyUSD(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  /// Format currency tanpa symbol (25.000)
  static String formatCurrencyWithoutSymbol(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: '',
      decimalDigits: 0,
    );
    return formatter.format(amount).trim();
  }

  // ===== DATE FORMATTING =====
  
  /// Format date: 20 Oktober 2025
  static String formatDate(DateTime date) {
    final formatter = DateFormat('dd MMMM yyyy', 'id_ID');
    return formatter.format(date);
  }

  /// Format date short: 20 Okt 2025
  static String formatDateShort(DateTime date) {
    final formatter = DateFormat('dd MMM yyyy', 'id_ID');
    return formatter.format(date);
  }

  /// Format date with time: 20 Okt 2025, 14:30
  static String formatDateTime(DateTime date) {
    final formatter = DateFormat('dd MMM yyyy, HH:mm', 'id_ID');
    return formatter.format(date);
  }

  /// Format time only: 14:30
  static String formatTime(DateTime date) {
    final formatter = DateFormat('HH:mm');
    return formatter.format(date);
  }

  /// Format date untuk input: 2025-10-20
  static String formatDateForInput(DateTime date) {
    final formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }

  /// Get relative time: "2 hari yang lalu", "1 jam yang lalu"
  static String formatRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years tahun yang lalu';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months bulan yang lalu';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} hari yang lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit yang lalu';
    } else {
      return 'Baru saja';
    }
  }

  // ===== NUMBER FORMATTING =====
  
  /// Format number dengan thousand separator: 1.000.000
  static String formatNumber(int number) {
    final formatter = NumberFormat('#,##0', 'id_ID');
    return formatter.format(number);
  }

  /// Format number dengan decimal: 1.234,56
  static String formatNumberWithDecimal(double number, {int decimalDigits = 2}) {
    final formatter = NumberFormat('#,##0.${'0' * decimalDigits}', 'id_ID');
    return formatter.format(number);
  }

  /// Format percentage: 85%
  static String formatPercentage(double value, {int decimalDigits = 0}) {
    final formatter = NumberFormat.percentPattern('id_ID');
    formatter.minimumFractionDigits = decimalDigits;
    formatter.maximumFractionDigits = decimalDigits;
    return formatter.format(value / 100);
  }

  /// Compact number format: 1K, 1M, 1B
  static String formatCompactNumber(int number) {
    final formatter = NumberFormat.compact(locale: 'id_ID');
    return formatter.format(number);
  }

  // ===== PHONE NUMBER FORMATTING =====
  
  /// Format phone number: 0812-3456-7890
  static String formatPhoneNumber(String phone) {
    // Remove all non-numeric characters
    final cleaned = phone.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleaned.length >= 10) {
      return '${cleaned.substring(0, 4)}-${cleaned.substring(4, 8)}-${cleaned.substring(8)}';
    }
    return phone;
  }

  // ===== FILE SIZE FORMATTING =====
  
  /// Format file size: 1.5 MB, 256 KB
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
    }
  }

  // ===== DURATION FORMATTING =====
  
  /// Format duration: 2h 30m
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  // ===== STRING FORMATTING =====
  
  /// Capitalize first letter: "hello" -> "Hello"
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  /// Title case: "hello world" -> "Hello World"
  static String toTitleCase(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) => capitalize(word)).join(' ');
  }

  /// Truncate text: "Long text..." (max 20 chars)
  static String truncate(String text, int maxLength, {String suffix = '...'}) {
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength - suffix.length) + suffix;
  }
}