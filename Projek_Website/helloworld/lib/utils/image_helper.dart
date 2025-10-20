// lib/utils/image_helper.dart
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// ✨ Helper class untuk handle image operations
/// Supports: Pick, Save, Delete images
class ImageHelper {
  static final ImagePicker _picker = ImagePicker();

  /// 📸 Pick image dari gallery atau camera
  /// Returns: File path (local) atau null jika cancel
  static Future<String?> pickImage({
    ImageSource source = ImageSource.gallery,
    int maxWidth = 1024,
    int maxHeight = 1024,
    int imageQuality = 85,
  }) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: maxWidth.toDouble(),
        maxHeight: maxHeight.toDouble(),
        imageQuality: imageQuality,
      );

      if (pickedFile == null) return null;

      // Untuk web, return path langsung
      if (kIsWeb) {
        return pickedFile.path;
      }

      // Untuk mobile/desktop, save ke app directory
      final savedPath = await _saveImageToAppDirectory(pickedFile);
      return savedPath;
    } catch (e) {
      debugPrint('Error picking image: $e');
      return null;
    }
  }

  /// 📸 Pick image dengan dialog pilihan (camera/gallery)
  static Future<String?> pickImageWithDialog(
    dynamic context, {
    int maxWidth = 1024,
    int maxHeight = 1024,
    int imageQuality = 85,
  }) async {
    // Jika web, langsung ke gallery (camera tidak support di web)
    if (kIsWeb) {
      return pickImage(
        source: ImageSource.gallery,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
      );
    }

    // Untuk mobile, tampilkan dialog pilihan
    final source = await _showImageSourceDialog(context);
    if (source == null) return null;

    return pickImage(
      source: source,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
    );
  }

  /// 💾 Save image ke app directory (internal storage)
  static Future<String?> _saveImageToAppDirectory(XFile file) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'product_$timestamp${path.extension(file.path)}';
      final savedPath = path.join(appDir.path, fileName);

      // Copy file ke app directory
      final bytes = await file.readAsBytes();
      final savedFile = File(savedPath);
      await savedFile.writeAsBytes(bytes);

      return savedPath;
    } catch (e) {
      debugPrint('Error saving image: $e');
      return null;
    }
  }

  /// 🗑️ Delete image dari storage
  static Future<bool> deleteImage(String? imagePath) async {
    if (imagePath == null || imagePath.isEmpty) return false;

    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting image: $e');
      return false;
    }
  }

  /// 📏 Get image file size (in bytes)
  static Future<int?> getImageSize(String? imagePath) async {
    if (imagePath == null || imagePath.isEmpty) return null;

    try {
      final file = File(imagePath);
      if (await file.exists()) {
        return await file.length();
      }
      return null;
    } catch (e) {
      debugPrint('Error getting image size: $e');
      return null;
    }
  }

  /// 📏 Get formatted image size (e.g., "1.5 MB")
  static Future<String?> getFormattedImageSize(String? imagePath) async {
    final bytes = await getImageSize(imagePath);
    if (bytes == null) return null;

    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  /// ✅ Check if image exists
  static Future<bool> imageExists(String? imagePath) async {
    if (imagePath == null || imagePath.isEmpty) return false;

    try {
      final file = File(imagePath);
      return await file.exists();
    } catch (e) {
      return false;
    }
  }

  /// 📱 Show dialog untuk pilih source (camera/gallery)
  static Future<ImageSource?> _showImageSourceDialog(dynamic context) async {
    return showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pilih Sumber Gambar'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library, color: Color(0xFF0D9488)),
              title: const Text('Gallery'),
              subtitle: const Text('Pilih dari galeri foto'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF0D9488)),
              title: const Text('Camera'),
              subtitle: const Text('Ambil foto baru'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );
  }

  /// 🖼️ Get File object dari path (untuk display di Image.file())
  static File? getImageFile(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return null;
    return File(imagePath);
  }

  /// 🌐 Check if path is network URL
  static bool isNetworkImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return false;
    return imagePath.startsWith('http://') || imagePath.startsWith('https://');
  }

  /// 🎨 Get image widget (auto-detect local/network)
  static Widget getImageWidget(
    String? imagePath, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? errorWidget,
  }) {
    if (imagePath == null || imagePath.isEmpty) {
      return errorWidget ?? 
          const Icon(Icons.image_not_supported, size: 50, color: Colors.grey);
    }

    // Network image
    if (isNetworkImage(imagePath)) {
      return Image.network(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) =>
            errorWidget ?? 
            const Icon(Icons.broken_image, size: 50, color: Colors.grey),
      );
    }

    // Local image (Web)
    if (kIsWeb) {
      return Image.network(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) =>
            errorWidget ?? 
            const Icon(Icons.broken_image, size: 50, color: Colors.grey),
      );
    }

    // Local image (Mobile/Desktop)
    final file = File(imagePath);
    return Image.file(
      file,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) =>
          errorWidget ?? 
          const Icon(Icons.broken_image, size: 50, color: Colors.grey),
    );
  }
}

/// 📦 Extension untuk kemudahan penggunaan
extension ImageHelperExtension on String? {
  /// Check if this string is a valid image path
  bool get isValidImagePath {
    if (this == null || this!.isEmpty) return false;
    final validExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp'];
    return validExtensions.any((ext) => this!.toLowerCase().endsWith(ext));
  }

  /// Get image widget dari path
  Widget toImageWidget({
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? errorWidget,
  }) {
    return ImageHelper.getImageWidget(
      this,
      width: width,
      height: height,
      fit: fit,
      errorWidget: errorWidget,
    );
  }
}