// lib/services/preferences_service.dart
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service untuk mengelola SharedPreferences
/// Menyimpan dan mengambil data lokal seperti settings, preferences, dll
class PreferencesService {
  static PreferencesService? _instance;
  static SharedPreferences? _preferences;

  // Private constructor
  PreferencesService._();

  // Singleton pattern
  static Future<PreferencesService> getInstance() async {
    _instance ??= PreferencesService._();
    _preferences ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  // Keys untuk SharedPreferences
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserId = 'user_id';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserName = 'user_name';
  static const String _keyUserRole = 'user_role';
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyLanguage = 'language';
  static const String _keyIsFirstLaunch = 'is_first_launch';
  static const String _keyRememberMe = 'remember_me';
  static const String _keyLastLoginDate = 'last_login_date';
  static const String _keyNotificationsEnabled = 'notifications_enabled';
  static const String _keyBiometricEnabled = 'biometric_enabled';

  // ==================== Authentication ====================

  /// Set login status
  Future<bool> setLoggedIn(bool value) async {
    return await _preferences!.setBool(_keyIsLoggedIn, value);
  }

  /// Get login status
  bool isLoggedIn() {
    return _preferences!.getBool(_keyIsLoggedIn) ?? false;
  }

  /// Save user data after login
  Future<bool> saveUserData({
    required String userId,
    required String email,
    required String name,
    required String role,
  }) async {
    final results = await Future.wait([
      _preferences!.setString(_keyUserId, userId),
      _preferences!.setString(_keyUserEmail, email),
      _preferences!.setString(_keyUserName, name),
      _preferences!.setString(_keyUserRole, role),
      _preferences!.setBool(_keyIsLoggedIn, true),
      _preferences!.setString(_keyLastLoginDate, DateTime.now().toIso8601String()),
    ]);
    return results.every((result) => result == true);
  }

  /// Get user ID
  String? getUserId() {
    return _preferences!.getString(_keyUserId);
  }

  /// Get user email
  String? getUserEmail() {
    return _preferences!.getString(_keyUserEmail);
  }

  /// Get user name
  String? getUserName() {
    return _preferences!.getString(_keyUserName);
  }

  /// Get user role
  String? getUserRole() {
    return _preferences!.getString(_keyUserRole);
  }

  /// Get last login date
  DateTime? getLastLoginDate() {
    final dateString = _preferences!.getString(_keyLastLoginDate);
    if (dateString != null) {
      return DateTime.tryParse(dateString);
    }
    return null;
  }

  /// Clear user data (logout)
  Future<bool> clearUserData() async {
    final results = await Future.wait([
      _preferences!.remove(_keyUserId),
      _preferences!.remove(_keyUserEmail),
      _preferences!.remove(_keyUserName),
      _preferences!.remove(_keyUserRole),
      _preferences!.setBool(_keyIsLoggedIn, false),
      _preferences!.remove(_keyLastLoginDate),
    ]);
    return results.every((result) => result == true);
  }

  // ==================== Remember Me ====================

  /// Set remember me
  Future<bool> setRememberMe(bool value) async {
    return await _preferences!.setBool(_keyRememberMe, value);
  }

  /// Get remember me
  bool getRememberMe() {
    return _preferences!.getBool(_keyRememberMe) ?? false;
  }

  // ==================== Theme Settings ====================

  /// Set theme mode (light, dark, system)
  /// Values: 'light', 'dark', 'system'
  Future<bool> setThemeMode(String mode) async {
    return await _preferences!.setString(_keyThemeMode, mode);
  }

  /// Get theme mode
  String getThemeMode() {
    return _preferences!.getString(_keyThemeMode) ?? 'light';
  }

  // ==================== Language Settings ====================

  /// Set language
  /// Values: 'en', 'id', etc
  Future<bool> setLanguage(String language) async {
    return await _preferences!.setString(_keyLanguage, language);
  }

  /// Get language
  String getLanguage() {
    return _preferences!.getString(_keyLanguage) ?? 'id';
  }

  // ==================== First Launch ====================

  /// Check if this is first launch
  bool isFirstLaunch() {
    return _preferences!.getBool(_keyIsFirstLaunch) ?? true;
  }

  /// Set first launch completed
  Future<bool> setFirstLaunchCompleted() async {
    return await _preferences!.setBool(_keyIsFirstLaunch, false);
  }

  // ==================== Notifications ====================

  /// Set notifications enabled
  Future<bool> setNotificationsEnabled(bool value) async {
    return await _preferences!.setBool(_keyNotificationsEnabled, value);
  }

  /// Get notifications enabled
  bool getNotificationsEnabled() {
    return _preferences!.getBool(_keyNotificationsEnabled) ?? true;
  }

  // ==================== Biometric ====================

  /// Set biometric enabled
  Future<bool> setBiometricEnabled(bool value) async {
    return await _preferences!.setBool(_keyBiometricEnabled, value);
  }

  /// Get biometric enabled
  bool getBiometricEnabled() {
    return _preferences!.getBool(_keyBiometricEnabled) ?? false;
  }

  // ==================== Generic Methods ====================

  /// Save string value
  Future<bool> setString(String key, String value) async {
    return await _preferences!.setString(key, value);
  }

  /// Get string value
  String? getString(String key) {
    return _preferences!.getString(key);
  }

  /// Save int value
  Future<bool> setInt(String key, int value) async {
    return await _preferences!.setInt(key, value);
  }

  /// Get int value
  int? getInt(String key) {
    return _preferences!.getInt(key);
  }

  /// Save double value
  Future<bool> setDouble(String key, double value) async {
    return await _preferences!.setDouble(key, value);
  }

  /// Get double value
  double? getDouble(String key) {
    return _preferences!.getDouble(key);
  }

  /// Save bool value
  Future<bool> setBool(String key, bool value) async {
    return await _preferences!.setBool(key, value);
  }

  /// Get bool value
  bool? getBool(String key) {
    return _preferences!.getBool(key);
  }

  /// Save list of strings
  Future<bool> setStringList(String key, List<String> value) async {
    return await _preferences!.setStringList(key, value);
  }

  /// Get list of strings
  List<String>? getStringList(String key) {
    return _preferences!.getStringList(key);
  }

  /// Remove specific key
  Future<bool> remove(String key) async {
    return await _preferences!.remove(key);
  }

  /// Check if key exists
  bool containsKey(String key) {
    return _preferences!.containsKey(key);
  }

  /// Clear all preferences
  Future<bool> clearAll() async {
    return await _preferences!.clear();
  }

  /// Get all keys
  Set<String> getAllKeys() {
    return _preferences!.getKeys();
  }

  // ==================== Utility Methods ====================

  /// Save object as JSON string (requires dart:convert)
  Future<bool> saveJson(String key, Map<String, dynamic> json) async {
    try {
      final jsonString = json.toString();
      return await setString(key, jsonString);
    } catch (e) {
      return false;
    }
  }

  /// Reload preferences (useful after external changes)
  Future<void> reload() async {
    await _preferences!.reload();
  }

  /// Print all stored preferences (for debugging)
final logger = Logger();

  void debugPrintAll() {
    final keys = _preferences!.getKeys();
  logger.i('=== SharedPreferences Debug ===');
  for (var key in keys) {
    logger.d('$key: ${_preferences!.get(key)}');
  }
  logger.i('==============================');
  }

  // ==================== User Settings Summary ====================

  /// Get complete user settings
  Map<String, dynamic> getUserSettings() {
    return {
      'isLoggedIn': isLoggedIn(),
      'userId': getUserId(),
      'userEmail': getUserEmail(),
      'userName': getUserName(),
      'userRole': getUserRole(),
      'themeMode': getThemeMode(),
      'language': getLanguage(),
      'notificationsEnabled': getNotificationsEnabled(),
      'biometricEnabled': getBiometricEnabled(),
      'rememberMe': getRememberMe(),
      'lastLoginDate': getLastLoginDate()?.toIso8601String(),
    };
  }

  /// Export all preferences as Map (for backup)
  Map<String, dynamic> exportAllPreferences() {
    final Map<String, dynamic> allPrefs = {};
    final keys = _preferences!.getKeys();
    
    for (var key in keys) {
      final value = _preferences!.get(key);
      allPrefs[key] = value;
    }
    
    return allPrefs;
  }
}