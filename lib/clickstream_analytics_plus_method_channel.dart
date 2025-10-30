import 'package:flutter/services.dart';
import 'clickstream_analytics_plus_platform_interface.dart';

/// An implementation of [ClickstreamAnalyticsPlusPlatform] that uses
/// [MethodChannel] to communicate with the native platform.
class MethodChannelClickstreamAnalyticsPlus
    extends ClickstreamAnalyticsPlusPlatform {
  /// The method channel used to interact with the native platform.
  static const MethodChannel _channel = MethodChannel(
    'clickstream_analytics_plus',
  );

  /// Initializes the Clickstream Analytics SDK on the native platform.
  ///
  /// Returns `true` if initialization was successful, otherwise `false`.
  @override
  Future<bool> initialize({
    required String appId,
    required String endpoint,
    bool? logEvents,
    bool? compressEvents,
    int? sessionTimeoutMs,
    int? sendEventIntervalMs,
    Map<String, dynamic>? initialGlobalAttributes,
  }) async {
    final result = await _channel.invokeMethod('initialize', {
      'appId': appId,
      'endpoint': endpoint,
      if (logEvents != null) 'logEvents': logEvents,
      if (compressEvents != null) 'compressEvents': compressEvents,
      if (sessionTimeoutMs != null) 'sessionTimeoutMs': sessionTimeoutMs,
      if (sendEventIntervalMs != null)
        'sendEventIntervalMs': sendEventIntervalMs,
      if (initialGlobalAttributes != null)
        'initialGlobalAttributes': initialGlobalAttributes,
    });
    if (result == true || result == 1 || result?.toString() == 'true') {
      return true;
    }
    return false;
  }

  /// Records an analytics event with the given [name] and optional [attributes].
  @override
  Future<void> recordEvent(
    String name, {
    Map<String, dynamic>? attributes,
  }) async {
    await _channel.invokeMethod('recordEvent', {
      'name': name,
      'attributes': attributes ?? {},
    });
  }

  /// Sets the user ID for analytics tracking.
  @override
  Future<void> setUserId(String userId) async {
    await _channel.invokeMethod('setUserId', {'userId': userId});
  }

  /// Sets user attributes for analytics tracking.
  @override
  Future<void> setUserAttributes(Map<String, dynamic> attributes) async {
    await _channel.invokeMethod('setUserAttributes', {
      'attributes': attributes,
    });
  }

  /// Flushes all queued analytics events to the backend.
  @override
  Future<void> flushEvents() async {
    await _channel.invokeMethod('flushEvents');
  }

  /// Pauses the current analytics session.
  @override
  Future<void> pauseSession() async {
    await _channel.invokeMethod('pauseSession');
  }

  /// Resumes the current analytics session.
  @override
  Future<void> resumeSession() async {
    await _channel.invokeMethod('resumeSession');
  }

  /// Sets global attributes for all analytics events.
  @override
  Future<void> setGlobalAttributes(Map<String, dynamic> attributes) async {
    await _channel.invokeMethod('setGlobalAttributes', {
      'attributes': attributes,
    });
  }

  /// Removes a global attribute by [key].
  @override
  Future<void> removeGlobalAttribute(String key) async {
    await _channel.invokeMethod('removeGlobalAttribute', {'key': key});
  }

  /// Enables or disables logging for the analytics SDK.
  @override
  Future<void> enableLogging(bool enabled) async {
    await _channel.invokeMethod('enableLogging', {'enabled': enabled});
  }

  /// Gets the SDK version from the native platform.
  @override
  Future<String?> getSdkVersion() async {
    final v = await _channel.invokeMethod('getSdkVersion');
    return v?.toString();
  }
}
