
import 'package:flutter/services.dart';

class NativeFilePicker {
  static const MethodChannel _channel = MethodChannel('kifiya_file_picker');

  static Future<String?> pickFile({List<String>? allowedTypes}) async {
    try {
      final String? path = await _channel.invokeMethod(
        'pickFile',
        {"allowedTypes": allowedTypes},
      );
      return path;
    } on PlatformException catch (e) {
      print('File pick failed: $e');
      return null;
    }
  }
}
