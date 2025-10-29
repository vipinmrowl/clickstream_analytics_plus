import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clickstream_analytics_plus/clickstream_analytics_plus_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelClickstreamAnalyticsPlus platform = MethodChannelClickstreamAnalyticsPlus();
  const MethodChannel channel = MethodChannel('clickstream_analytics_plus');

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
