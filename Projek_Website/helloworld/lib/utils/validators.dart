// lib/utils/validators.dart
import '../constants/app_constants.dart';

class Validators {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    
    value = value.trim();
    
    // Basic email regex pattern
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Format email tidak valid';
    }
    
    // Check for common invalid patterns
    if (value.contains('..') || value.startsWith('.') || value.endsWith('.')) {
      return 'Format email tidak valid';
    }
    
    return null;
  }
  
  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    
    if (value.length < AppConstants.minPasswordLength) {
      return 'Password minimal ${AppConstants.minPasswordLength} karakter';
    }
    
    if (value.length > AppConstants.maxPasswordLength) {
      return 'Password maksimal ${AppConstants.maxPasswordLength} karakter';
    }
    
    // Check for at least one letter and one number (optional, for stronger passwords)
    // if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(value)) {
    //   return 'Password harus mengandung huruf dan angka';
    // }
    
    return null;
  }
  
  // Strong password validation (optional)
  static String? validateStrongPassword(String? value) {
    final basicValidation = validatePassword(value);
    if (basicValidation != null) return basicValidation;
    
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]').hasMatch(value!)) {
      return 'Password harus mengandung huruf besar, huruf kecil, angka, dan simbol';
    }
    
    return null;
  }
  
  // Name validation
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    
    value = value.trim();
    
    if (value.length < AppConstants.minNameLength) {
      return 'Nama minimal ${AppConstants.minNameLength} karakter';
    }
    
    if (value.length > AppConstants.maxNameLength) {
      return 'Nama maksimal ${AppConstants.maxNameLength} karakter';
    }
    
    // Check for valid characters (letters, spaces, hyphens, apostrophes)
    if (!RegExp(r"^[a-zA-Z\s\-']+$").hasMatch(value)) {
      return 'Nama hanya boleh mengandung huruf, spasi, tanda hubung, dan apostrof';
    }
    
    return null;
  }
  
  // Confirm password validation
  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }
    
    if (value != password) {
      return 'Password tidak cocok';
    }
    
    return null;
  }
  
  // Generic required field validation
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    
    return null;
  }
  
  // Product title validation
  static String? validateProductTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Judul produk tidak boleh kosong';
    }
    
    value = value.trim();
    
    if (value.length < AppConstants.minProductTitleLength) {
      return 'Judul produk minimal ${AppConstants.minProductTitleLength} karakter';
    }
    
    if (value.length > AppConstants.maxProductTitleLength) {
      return 'Judul produk maksimal ${AppConstants.maxProductTitleLength} karakter';
    }
    
    return null;
  }
  
  // Product description validation
  static String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Deskripsi tidak boleh kosong';
    }
    
    value = value.trim();
    
    if (value.length < AppConstants.minDescriptionLength) {
      return 'Deskripsi minimal ${AppConstants.minDescriptionLength} karakter';
    }
    
    if (value.length > AppConstants.maxDescriptionLength) {
      return 'Deskripsi maksimal ${AppConstants.maxDescriptionLength} karakter';
    }
    
    return null;
  }
  
  // Price validation
  static String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Harga tidak boleh kosong';
    }
    
    final price = double.tryParse(value);
    if (price == null) {
      return 'Format harga tidak valid';
    }
    
    if (price < 0) {
      return 'Harga tidak boleh negatif';
    }
    
    if (price > 999999.99) {
      return 'Harga maksimal 999,999.99';
    }
    
    return null;
  }
  
  // Phone number validation (Indonesian format)
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }
    
    // Remove all non-digit characters
    final cleanValue = value.replaceAll(RegExp(r'\D'), '');
    
    // Indonesian phone number patterns
    if (!RegExp(r'^(62|0)[0-9]{8,12}$').hasMatch(cleanValue)) {
      return 'Format nomor telepon tidak valid';
    }
    
    return null;
  }
  
  // URL validation
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'URL tidak boleh kosong';
    }
    
    try {
      Uri.parse(value);
      if (!value.startsWith('http://') && !value.startsWith('https://')) {
        return 'URL harus dimulai dengan http:// atau https://';
      }
      return null;
    } catch (e) {
      return 'Format URL tidak valid';
    }
  }
  
  // Integer validation
  static String? validateInteger(String? value, {int? min, int? max}) {
    if (value == null || value.isEmpty) {
      return 'Nilai tidak boleh kosong';
    }
    
    final intValue = int.tryParse(value);
    if (intValue == null) {
      return 'Nilai harus berupa angka bulat';
    }
    
    if (min != null && intValue < min) {
      return 'Nilai minimal $min';
    }
    
    if (max != null && intValue > max) {
      return 'Nilai maksimal $max';
    }
    
    return null;
  }
  
  // Double validation
  static String? validateDouble(String? value, {double? min, double? max}) {
    if (value == null || value.isEmpty) {
      return 'Nilai tidak boleh kosong';
    }
    
    final doubleValue = double.tryParse(value);
    if (doubleValue == null) {
      return 'Format angka tidak valid';
    }
    
    if (min != null && doubleValue < min) {
      return 'Nilai minimal $min';
    }
    
    if (max != null && doubleValue > max) {
      return 'Nilai maksimal $max';
    }
    
    return null;
  }
  
  // Credit card validation (basic)
  static String? validateCreditCard(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor kartu kredit tidak boleh kosong';
    }
    
    final cleanValue = value.replaceAll(RegExp(r'\D'), '');
    
    if (cleanValue.length < 13 || cleanValue.length > 19) {
      return 'Nomor kartu kredit tidak valid';
    }
    
    // Luhn algorithm check
    int sum = 0;
    bool alternate = false;
    
    for (int i = cleanValue.length - 1; i >= 0; i--) {
      int digit = int.parse(cleanValue[i]);
      
      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit = (digit % 10) + 1;
        }
      }
      
      sum += digit;
      alternate = !alternate;
    }
    
    if (sum % 10 != 0) {
      return 'Nomor kartu kredit tidak valid';
    }
    
    return null;
  }
}