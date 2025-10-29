import 'clickstream_analytics_plus_platform_interface.dart';

class ClickstreamAnalyticsPlus {
  static ClickstreamAnalyticsPlusPlatform get _platform =>
      ClickstreamAnalyticsPlusPlatform.instance;
  Future<bool> initialize({required String appId, required String endpoint}) =>
      _platform.initialize(appId: appId, endpoint: endpoint);

  Future<void> recordEvent(String name, {Map<String, dynamic>? attributes}) =>
      _platform.recordEvent(name, attributes: attributes);

  Future<void> setUserId(String userId) => _platform.setUserId(userId);

  Future<void> setUserAttributes(Map<String, String> attributes) =>
      _platform.setUserAttributes(attributes);

  Future<void> flushEvents() => _platform.flushEvents();
}
