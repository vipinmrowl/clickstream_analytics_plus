import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:clickstream_analytics_plus/clickstream_analytics_plus.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('ClickstreamAnalyticsPlus integration test', (
    WidgetTester tester,
  ) async {
    final plugin = ClickstreamAnalyticsPlus();

    // Initialize SDK
    final ok = await plugin.initialize(
      appId: 'AppId',
      endpoint: 'https://events.example.com/collect',
      logEvents: true,
      compressEvents: true,
      sessionTimeoutMs: 1800000,
      sendEventIntervalMs: 10000,
      initialGlobalAttributes: {
        'platform': 'flutter',
        'build': 'integration_test',
      },
    );
    expect(ok, isTrue);

    // Set user ID
    await plugin.setUserId('integration_user_1');

    // Set user attributes
    await plugin.setUserAttributes({'plan': 'Integration', 'region': 'Test'});

    // Record an event
    await plugin.recordEvent(
      'integration_test_event',
      attributes: {'timestamp': DateTime.now().toIso8601String(), 'test': true},
    );

    // Flush events
    await plugin.flushEvents();

    // Get SDK version
    final sdkVersion = await plugin.getSdkVersion();
    expect(sdkVersion, isNotNull);
    expect(sdkVersion!.isNotEmpty, isTrue);
  });
}
