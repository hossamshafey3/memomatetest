// ─────────────────────────────────────────────
//  image_upload_service.dart  –  Memomate
//  Uploads an image file to Cloudinary and
//  returns the hosted URL.
// ─────────────────────────────────────────────

import 'dart:io';
import 'package:dio/dio.dart';

class ImageUploadService {
  static const String _cloudName = 'dws7kszsk';
  static const String _uploadPreset = 'dws7kszsk';
  static const String _uploadUrl =
      'https://api.cloudinary.com/v1_1/$_cloudName/image/upload';

  final Dio _dio;

  ImageUploadService({Dio? dio}) : _dio = dio ?? Dio();

  /// Uploads [file] to Cloudinary and returns the secure URL.
  /// Throws [Exception] if the upload fails.
  Future<String> uploadImage(File file) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      ),
      'upload_preset': _uploadPreset,
    });

    final response = await _dio.post(_uploadUrl, data: formData);

    if (response.statusCode == 200) {
      final secureUrl = response.data['secure_url'] as String?;
      if (secureUrl != null && secureUrl.isNotEmpty) {
        return secureUrl;
      }
    }

    throw Exception('Image upload failed. Status: ${response.statusCode}');
  }
}
