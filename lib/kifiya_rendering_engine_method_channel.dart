import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'kifiya_rendering_engine_platform_interface.dart';

/// An implementation of [KifiyaRenderingEnginePlatform] that uses method channels.
class MethodChannelKifiyaRenderingEngine extends KifiyaRenderingEnginePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('kifiya_rendering_engine');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
