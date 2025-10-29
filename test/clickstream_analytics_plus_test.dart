import 'package:flutter_test/flutter_test.dart';
import 'package:clickstream_analytics_plus/clickstream_analytics_plus.dart';
import 'package:clickstream_analytics_plus/clickstream_analytics_plus_platform_interface.dart';
import 'package:clickstream_analytics_plus/clickstream_analytics_plus_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockClickstreamAnalyticsPlusPlatform
    with MockPlatformInterfaceMixin
    implements ClickstreamAnalyticsPlusPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final ClickstreamAnalyticsPlusPlatform initialPlatform = ClickstreamAnalyticsPlusPlatform.instance;

  test('$MethodChannelClickstreamAnalyticsPlus is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelClickstreamAnalyticsPlus>());
  });

  test('getPlatformVersion', () async {
    ClickstreamAnalyticsPlus clickstreamAnalyticsPlusPlugin = ClickstreamAnalyticsPlus();
    MockClickstreamAnalyticsPlusPlatform fakePlatform = MockClickstreamAnalyticsPlusPlatform();
    ClickstreamAnalyticsPlusPlatform.instance = fakePlatform;

    expect(await clickstreamAnalyticsPlusPlugin.getPlatformVersion(), '42');
  });
}
