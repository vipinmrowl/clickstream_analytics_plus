import 'clickstream_analytics_plus_platform_interface.dart';

class ClickstreamAnalyticsPlus {
  static ClickstreamAnalyticsPlusPlatform get _platform =>
      ClickstreamAnalyticsPlusPlatform.instance;

  Future<bool> initialize({
    required String appId,
    required String endpoint,
    bool? logEvents,
    bool? compressEvents,
    int? sessionTimeoutMs,
    int? sendEventIntervalMs,
    Map<String, dynamic>? initialGlobalAttributes,
  }) => _platform.initialize(
    appId: appId,
    endpoint: endpoint,
    logEvents: logEvents,
    compressEvents: compressEvents,
    sessionTimeoutMs: sessionTimeoutMs,
    sendEventIntervalMs: sendEventIntervalMs,
    initialGlobalAttributes: initialGlobalAttributes,
  );

  Future<void> recordEvent(String name, {Map<String, dynamic>? attributes}) =>
      _platform.recordEvent(name, attributes: attributes);

  Future<void> setUserId(String userId) => _platform.setUserId(userId);

  Future<void> setUserAttributes(Map<String, dynamic> attributes) =>
      _platform.setUserAttributes(attributes);

  Future<void> setGlobalAttributes(Map<String, dynamic> attributes) =>
      _platform.setGlobalAttributes(attributes);

  Future<void> removeGlobalAttribute(String key) =>
      _platform.removeGlobalAttribute(key);

  Future<void> pauseSession() => _platform.pauseSession();

  Future<void> resumeSession() => _platform.resumeSession();

  Future<void> enableLogging(bool enabled) => _platform.enableLogging(enabled);

  Future<String?> getSdkVersion() => _platform.getSdkVersion();

  Future<void> flushEvents() => _platform.flushEvents();
}
