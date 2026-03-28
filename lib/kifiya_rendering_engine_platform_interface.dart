import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'kifiya_rendering_engine_method_channel.dart';

abstract class KifiyaRenderingEnginePlatform extends PlatformInterface {
  /// Constructs a KifiyaRenderingEnginePlatform.
  KifiyaRenderingEnginePlatform() : super(token: _token);

  static final Object _token = Object();

  static KifiyaRenderingEnginePlatform _instance = MethodChannelKifiyaRenderingEngine();

  /// The default instance of [KifiyaRenderingEnginePlatform] to use.
  ///
  /// Defaults to [MethodChannelKifiyaRenderingEngine].
  static KifiyaRenderingEnginePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [KifiyaRenderingEnginePlatform] when
  /// they register themselves.
  static set instance(KifiyaRenderingEnginePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
