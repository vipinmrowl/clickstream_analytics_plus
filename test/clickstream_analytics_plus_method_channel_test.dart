import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clickstream_analytics_plus/clickstream_analytics_plus_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelClickstreamAnalyticsPlus platform =
      MethodChannelClickstreamAnalyticsPlus();
  const MethodChannel channel = MethodChannel('clickstream_analytics_plus');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          // Return values based on method name for more realistic tests
          switch (methodCall.method) {
            case 'initialize':
              return true;
            case 'recordEvent':
            case 'setUserId':
            case 'setUserAttributes':
            case 'flushEvents':
            case 'pauseSession':
            case 'resumeSession':
            case 'setGlobalAttributes':
            case 'removeGlobalAttribute':
            case 'enableLogging':
              return null;
            case 'getSdkVersion':
              return '1.2.3';
            default:
              return null;
          }
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('initialize returns true', () async {
    final result = await platform.initialize(
      appId: 'appid',
      endpoint: 'endpoint',
    );
    expect(result, isTrue);
  });

  test('recordEvent completes', () async {
    await platform.recordEvent('test_event', attributes: {'foo': 'bar'});
  });

  test('setUserId completes', () async {
    await platform.setUserId('user123');
  });

  test('setUserAttributes completes', () async {
    await platform.setUserAttributes({'attr': 'val'});
  });

  test('flushEvents completes', () async {
    await platform.flushEvents();
  });

  test('pauseSession completes', () async {
    await platform.pauseSession();
  });

  test('resumeSession completes', () async {
    await platform.resumeSession();
  });

  test('setGlobalAttributes completes', () async {
    await platform.setGlobalAttributes({'global': 'attr'});
  });

  test('removeGlobalAttribute completes', () async {
    await platform.removeGlobalAttribute('key');
  });

  test('enableLogging completes', () async {
    await platform.enableLogging(true);
  });

  test('getSdkVersion returns string', () async {
    final version = await platform.getSdkVersion();
    expect(version, '1.2.3');
  });
}
