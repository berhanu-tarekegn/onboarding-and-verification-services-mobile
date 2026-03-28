import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kifiya_rendering_engine/kifiya_rendering_engine_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelKifiyaRenderingEngine platform = MethodChannelKifiyaRenderingEngine();
  const MethodChannel channel = MethodChannel('kifiya_rendering_engine');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
