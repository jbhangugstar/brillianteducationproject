import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

class ImageHelper {
  static ImageProvider getImageProvider(String? imageSource) {
    if (imageSource == null || imageSource.trim().isEmpty) {
      return const AssetImage('assets/image/applogo.png');
    }

    // 1. Check if it's a URL
    if (imageSource.startsWith('http://') || imageSource.startsWith('https://')) {
      return NetworkImage(imageSource);
    }

    // 2. Check if it's a File path (Local)
    if (imageSource.startsWith('/') || imageSource.contains(':\\') || imageSource.contains(':/')) {
      final file = File(imageSource);
      if (file.existsSync()) {
        return FileImage(file);
      }
    }

    // 3. Check if it's an Asset
    if (imageSource.startsWith('assets/')) {
      return AssetImage(imageSource);
    }

    // 4. Try to decode as Base64
    try {
      String base64String = imageSource;
      if (imageSource.contains(',')) {
        base64String = imageSource.split(',').last;
      }
      // Remove whitespace and check if it looks like base64
      base64String = base64String.replaceAll(RegExp(r'\s+'), '');
      return MemoryImage(base64Decode(base64String));
    } catch (e) {
      debugPrint('ImageHelper: Failed to decode base64 - ${e.toString().substring(0, 50)}...');
      return const AssetImage('assets/image/applogo.png');
    }
  }

  static Widget buildImage(String? imageSource, {double? width, double? height, BoxFit fit = BoxFit.cover, Widget? errorWidget}) {
    if (imageSource == null || imageSource.trim().isEmpty) {
      return errorWidget ?? _buildPlaceholder(width, height);
    }

    // URL handling
    if (imageSource.startsWith('http')) {
      return Image.network(
        imageSource,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => errorWidget ?? _buildPlaceholder(width, height),
      );
    }

    // File handling
    if (imageSource.startsWith('/') || imageSource.contains(':\\') || imageSource.contains(':/')) {
      final file = File(imageSource);
      if (file.existsSync()) {
        return Image.file(
          file,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) => errorWidget ?? _buildPlaceholder(width, height),
        );
      }
    }

    // Asset handling
    if (imageSource.startsWith('assets/')) {
       return Image.asset(
          imageSource,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) => errorWidget ?? _buildPlaceholder(width, height),
       );
    }

    // Base64 handling
    try {
      String base64String = imageSource;
      if (imageSource.contains(',')) {
        base64String = imageSource.split(',').last;
      }
      base64String = base64String.replaceAll(RegExp(r'\s+'), '');
      return Image.memory(
        base64Decode(base64String),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('ImageHelper: Image.memory error builder triggered');
          return errorWidget ?? _buildPlaceholder(width, height);
        },
      );
    } catch (e) {
      debugPrint('ImageHelper: buildImage failed to decode base64');
      return errorWidget ?? _buildPlaceholder(width, height);
    }
  }

  static Widget _buildPlaceholder(double? width, double? height) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: Center(
        child: Icon(Icons.image_not_supported_outlined, color: Colors.grey[400], size: 30),
      ),
    );
  }
}
