import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'clickstream_analytics_plus_method_channel.dart';

abstract class ClickstreamAnalyticsPlusPlatform extends PlatformInterface {
  /// Constructs a ClickstreamAnalyticsPlusPlatform.
  ClickstreamAnalyticsPlusPlatform() : super(token: _token);

  static final Object _token = Object();

  static ClickstreamAnalyticsPlusPlatform _instance =
      MethodChannelClickstreamAnalyticsPlus();

  /// The default instance of [ClickstreamAnalyticsPlusPlatform] to use.
  ///
  /// Defaults to [MethodChannelClickstreamAnalyticsPlus].
  static ClickstreamAnalyticsPlusPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ClickstreamAnalyticsPlusPlatform] when
  /// they register themselves.
  static set instance(ClickstreamAnalyticsPlusPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool> initialize({
    required String appId,
    required String endpoint,
  }) async {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  Future<void> recordEvent(
    String name, {
    Map<String, dynamic>? attributes,
  }) async {
    throw UnimplementedError('recordEvent() has not been implemented.');
  }

  Future<void> setUserId(String userId) async {
    throw UnimplementedError('setUserId() has not been implemented.');
  }

  Future<void> setUserAttributes(Map<String, String> attributes) async {
    throw UnimplementedError('setUserAttributes() has not been implemented.');
  }

  Future<void> flushEvents() async {
    throw UnimplementedError('flushEvents() has not been implemented.');
  }
}
