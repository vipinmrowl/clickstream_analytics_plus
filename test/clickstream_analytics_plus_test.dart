import 'package:clickstream_analytics_plus/clickstream_analytics_plus.dart';
import 'package:clickstream_analytics_plus/clickstream_analytics_plus_method_channel.dart';
import 'package:clickstream_analytics_plus/clickstream_analytics_plus_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockClickstreamAnalyticsPlusPlatform
    with MockPlatformInterfaceMixin
    implements ClickstreamAnalyticsPlusPlatform {
  @override
  Future<bool> initialize({
    required String appId,
    required String endpoint,
    bool? logEvents,
    bool? compressEvents,
    int? sessionTimeoutMs,
    int? sendEventIntervalMs,
    Map<String, dynamic>? initialGlobalAttributes,
  }) => Future.value(true);

  @override
  Future<void> recordEvent(
    String name, {
    Map<String, dynamic>? attributes,
  }) async {}

  @override
  Future<void> setUserId(String userId) async {}

  @override
  Future<void> setUserAttributes(Map<String, dynamic> attributes) async {}

  @override
  Future<void> setGlobalAttributes(Map<String, dynamic> attributes) async {}

  @override
  Future<void> removeGlobalAttribute(String key) async {}

  @override
  Future<void> pauseSession() async {}

  @override
  Future<void> resumeSession() async {}

  @override
  Future<void> enableLogging(bool enabled) async {}

  @override
  Future<String?> getSdkVersion() => Future.value('1.2.3');

  @override
  Future<void> flushEvents() async {}
}

void main() {
  final initialPlatform = ClickstreamAnalyticsPlusPlatform.instance;

  test('MethodChannelClickstreamAnalyticsPlus is the default instance', () {
    expect(initialPlatform, isA<MethodChannelClickstreamAnalyticsPlus>());
  });

  test('initialize returns true', () async {
    final plugin = ClickstreamAnalyticsPlus();
    final fakePlatform = MockClickstreamAnalyticsPlusPlatform();
    ClickstreamAnalyticsPlusPlatform.instance = fakePlatform;
    expect(
      await plugin.initialize(appId: 'appid', endpoint: 'endpoint'),
      isTrue,
    );
  });

  test('recordEvent completes', () async {
    final plugin = ClickstreamAnalyticsPlus();
    final fakePlatform = MockClickstreamAnalyticsPlusPlatform();
    ClickstreamAnalyticsPlusPlatform.instance = fakePlatform;
    await plugin.recordEvent('event', attributes: {'foo': 'bar'});
  });

  test('setUserId completes', () async {
    final plugin = ClickstreamAnalyticsPlus();
    final fakePlatform = MockClickstreamAnalyticsPlusPlatform();
    ClickstreamAnalyticsPlusPlatform.instance = fakePlatform;
    await plugin.setUserId('user123');
  });

  test('setUserAttributes completes', () async {
    final plugin = ClickstreamAnalyticsPlus();
    final fakePlatform = MockClickstreamAnalyticsPlusPlatform();
    ClickstreamAnalyticsPlusPlatform.instance = fakePlatform;
    await plugin.setUserAttributes({'attr': 'val'});
  });

  test('setGlobalAttributes completes', () async {
    final plugin = ClickstreamAnalyticsPlus();
    final fakePlatform = MockClickstreamAnalyticsPlusPlatform();
    ClickstreamAnalyticsPlusPlatform.instance = fakePlatform;
    await plugin.setGlobalAttributes({'global': 'attr'});
  });

  test('removeGlobalAttribute completes', () async {
    final plugin = ClickstreamAnalyticsPlus();
    final fakePlatform = MockClickstreamAnalyticsPlusPlatform();
    ClickstreamAnalyticsPlusPlatform.instance = fakePlatform;
    await plugin.removeGlobalAttribute('key');
  });

  test('pauseSession completes', () async {
    final plugin = ClickstreamAnalyticsPlus();
    final fakePlatform = MockClickstreamAnalyticsPlusPlatform();
    ClickstreamAnalyticsPlusPlatform.instance = fakePlatform;
    await plugin.pauseSession();
  });

  test('resumeSession completes', () async {
    final plugin = ClickstreamAnalyticsPlus();
    final fakePlatform = MockClickstreamAnalyticsPlusPlatform();
    ClickstreamAnalyticsPlusPlatform.instance = fakePlatform;
    await plugin.resumeSession();
  });

  test('enableLogging completes', () async {
    final plugin = ClickstreamAnalyticsPlus();
    final fakePlatform = MockClickstreamAnalyticsPlusPlatform();
    ClickstreamAnalyticsPlusPlatform.instance = fakePlatform;
    await plugin.enableLogging(true);
  });

  test('getSdkVersion returns string', () async {
    final plugin = ClickstreamAnalyticsPlus();
    final fakePlatform = MockClickstreamAnalyticsPlusPlatform();
    ClickstreamAnalyticsPlusPlatform.instance = fakePlatform;
    expect(await plugin.getSdkVersion(), '1.2.3');
  });

  test('flushEvents completes', () async {
    final plugin = ClickstreamAnalyticsPlus();
    final fakePlatform = MockClickstreamAnalyticsPlusPlatform();
    ClickstreamAnalyticsPlusPlatform.instance = fakePlatform;
    await plugin.flushEvents();
  });
}
