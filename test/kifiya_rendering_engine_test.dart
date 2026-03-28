import 'package:flutter_test/flutter_test.dart';
import 'package:kifiya_rendering_engine/kifiya_rendering_engine.dart';
import 'package:kifiya_rendering_engine/kifiya_rendering_engine_platform_interface.dart';
import 'package:kifiya_rendering_engine/kifiya_rendering_engine_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockKifiyaRenderingEnginePlatform
    with MockPlatformInterfaceMixin
    implements KifiyaRenderingEnginePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final KifiyaRenderingEnginePlatform initialPlatform = KifiyaRenderingEnginePlatform.instance;

  test('$MethodChannelKifiyaRenderingEngine is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelKifiyaRenderingEngine>());
  });

  // test('getPlatformVersion', () async {
  //   KifiyaRenderingEngine kifiyaRenderingEnginePlugin = KifiyaRenderingEngine();
  //   MockKifiyaRenderingEnginePlatform fakePlatform = MockKifiyaRenderingEnginePlatform();
  //   KifiyaRenderingEnginePlatform.instance = fakePlatform;
  //
  //   expect(await kifiyaRenderingEnginePlugin.getPlatformVersion(), '42');
  // });
}
