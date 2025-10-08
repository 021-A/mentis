// lib/utils/date_utils.dart
import 'package:intl/intl.dart';

class AppDateUtils {
  // Date formatters
  static final DateFormat _dayMonthYear = DateFormat('dd/MM/yyyy');
  static final DateFormat _dayMonthYearTime = DateFormat('dd/MM/yyyy HH:mm');
  static final DateFormat _monthYear = DateFormat('MMM yyyy');
  static final DateFormat _dayMonth = DateFormat('dd MMM');
  static final DateFormat _timeOnly = DateFormat('HH:mm');
  static final DateFormat _dateOnly = DateFormat('dd MMM yyyy');
  static final DateFormat _iso8601 = DateFormat('yyyy-MM-ddTHH:mm:ss.SSS');
  
  // Basic date formatting
  static String formatDate(DateTime date) {
    return _dayMonthYear.format(date);
  }
  
  static String formatDateTime(DateTime dateTime) {
    return _dayMonthYearTime.format(dateTime);
  }
  
  static String formatDateOnly(DateTime date) {
    return _dateOnly.format(date);
  }
  
  static String formatTimeOnly(DateTime time) {
    return _timeOnly.format(time);
  }
  
  static String formatMonthYear(DateTime date) {
    return _monthYear.format(date);
  }
  
  static String formatDayMonth(DateTime date) {
    return _dayMonth.format(date);
  }
  
  // Relative time formatting
  static String getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
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
  
  static String getTimeUntil(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);
    
    if (difference.isNegative) {
      return 'Sudah lewat';
    }
    
    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years tahun lagi';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months bulan lagi';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} hari lagi';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam lagi';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit lagi';
    } else {
      return 'Sebentar lagi';
    }
  }
  
  // Date comparisons
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }
  
  static bool isToday(DateTime date) {
    return isSameDay(date, DateTime.now());
  }
  
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return isSameDay(date, yesterday);
  }
  
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return isSameDay(date, tomorrow);
  }
  
  static bool isThisWeek(DateTime date) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    
    return date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
           date.isBefore(endOfWeek.add(const Duration(days: 1)));
  }
  
  static bool isThisMonth(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }
  
  static bool isThisYear(DateTime date) {
    return date.year == DateTime.now().year;
  }
  
  // Date calculations
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
  
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }
  
  static DateTime startOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }
  
  static DateTime endOfWeek(DateTime date) {
    final startWeek = startOfWeek(date);
    return startWeek.add(const Duration(days: 6));
  }
  
  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }
  
  static DateTime endOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0);
  }
  
  static DateTime startOfYear(DateTime date) {
    return DateTime(date.year, 1, 1);
  }
  
  static DateTime endOfYear(DateTime date) {
    return DateTime(date.year, 12, 31);
  }
  
  // Age calculation
  static int calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    
    if (now.month < birthDate.month || 
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    
    return age;
  }
  
  // Working days calculation (excluding weekends)
  static int getWorkingDaysBetween(DateTime start, DateTime end) {
    if (start.isAfter(end)) {
      return 0;
    }
    
    int workingDays = 0;
    DateTime current = DateTime(start.year, start.month, start.day);
    final endDate = DateTime(end.year, end.month, end.day);
    
    while (current.isBefore(endDate) || current.isAtSameMomentAs(endDate)) {
      if (current.weekday != DateTime.saturday && 
          current.weekday != DateTime.sunday) {
        workingDays++;
      }
      current = current.add(const Duration(days: 1));
    }
    
    return workingDays;
  }
  
  // Get days in month
  static int getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }
  
  // Check if leap year
  static bool isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }
  
  // Add business days (excluding weekends)
  static DateTime addBusinessDays(DateTime date, int days) {
    DateTime result = date;
    int addedDays = 0;
    
    while (addedDays < days) {
      result = result.add(const Duration(days: 1));
      if (result.weekday != DateTime.saturday && 
          result.weekday != DateTime.sunday) {
        addedDays++;
      }
    }
    
    return result;
  }
  
  // Get next working day
  static DateTime getNextWorkingDay(DateTime date) {
    DateTime nextDay = date.add(const Duration(days: 1));
    
    while (nextDay.weekday == DateTime.saturday || 
           nextDay.weekday == DateTime.sunday) {
      nextDay = nextDay.add(const Duration(days: 1));
    }
    
    return nextDay;
  }
  
  // Format duration
  static String formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays} hari';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} jam';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} menit';
    } else {
      return '${duration.inSeconds} detik';
    }
  }
  
  // Parse date from string
  static DateTime? parseDate(String dateString) {
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      try {
        return _dayMonthYear.parse(dateString);
      } catch (e) {
        try {
          return _dayMonthYearTime.parse(dateString);
        } catch (e) {
          return null;
        }
      }
    }
  }
  
  // Convert to ISO 8601 string
  static String toIsoString(DateTime date) {
    return _iso8601.format(date);
  }
  
  // Get Indonesian day name
  static String getIndonesianDayName(DateTime date) {
    const dayNames = [
      '', // DateTime.weekday starts from 1 (Monday)
      'Senin',
      'Selasa', 
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu'
    ];
    return dayNames[date.weekday];
  }
  
  // Get Indonesian month name
  static String getIndonesianMonthName(DateTime date) {
    const monthNames = [
      '', // Month starts from 1 (January)
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return monthNames[date.month];
  }
  
  // Format date in Indonesian
  static String formatIndonesianDate(DateTime date) {
    return '${date.day} ${getIndonesianMonthName(date)} ${date.year}';
  }
  
  // Format date with Indonesian day name
  static String formatIndonesianDateTime(DateTime date) {
    return '${getIndonesianDayName(date)}, ${formatIndonesianDate(date)}';
  }
  
  // Get quarter of year
  static int getQuarter(DateTime date) {
    return ((date.month - 1) ~/ 3) + 1;
  }
  
  // Check if date is in past
  static bool isPast(DateTime date) {
    return date.isBefore(DateTime.now());
  }
  
  // Check if date is in future
  static bool isFuture(DateTime date) {
    return date.isAfter(DateTime.now());
  }
  
  // Get midnight time
  static DateTime getMidnight(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
  
  // Get end of day time
  static DateTime getEndOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999, 999);
  }
}