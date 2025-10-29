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
    bool? logEvents,
    bool? compressEvents,
    int? sessionTimeoutMs,
    int? sendEventIntervalMs,
    Map<String, dynamic>? initialGlobalAttributes,
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

  Future<void> setUserAttributes(Map<String, dynamic> attributes) async {
    throw UnimplementedError('setUserAttributes() has not been implemented.');
  }

  Future<void> flushEvents() async {
    throw UnimplementedError('flushEvents() has not been implemented.');
  }

  Future<void> pauseSession() async {
    throw UnimplementedError('pauseSession() has not been implemented.');
  }

  Future<void> resumeSession() async {
    throw UnimplementedError('resumeSession() has not been implemented.');
  }

  Future<void> setGlobalAttributes(Map<String, dynamic> attributes) async {
    throw UnimplementedError('setGlobalAttributes() has not been implemented.');
  }

  Future<void> removeGlobalAttribute(String key) async {
    throw UnimplementedError(
      'removeGlobalAttribute() has not been implemented.',
    );
  }

  Future<void> enableLogging(bool enabled) async {
    throw UnimplementedError('enableLogging() has not been implemented.');
  }

  Future<String?> getSdkVersion() async {
    throw UnimplementedError('getSdkVersion() has not been implemented.');
  }
}
