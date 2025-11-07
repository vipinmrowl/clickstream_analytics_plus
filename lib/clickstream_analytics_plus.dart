// Main entry point for Clickstream Analytics Plus Dart API.
// Import this file to access the platform-agnostic Clickstream Analytics API.
//
// Example:
// ```dart
// import 'package:clickstream_analytics_plus/clickstream_analytics_plus.dart';
// ```
import 'clickstream_analytics_plus_platform_interface.dart';

/// Dart API for Clickstream Analytics Plus.

///
/// This class provides a platform-agnostic interface for initializing and interacting
/// with the Clickstream Analytics SDK. It delegates calls to the platform-specific
/// implementation via [ClickstreamAnalyticsPlusPlatform].
/// Dart API for Clickstream Analytics Plus.
///
/// This class provides a platform-agnostic interface for initializing and interacting
/// with the Clickstream Analytics SDK. It delegates calls to the platform-specific
/// implementation via [ClickstreamAnalyticsPlusPlatform].
class ClickstreamAnalyticsPlus {
  /// The platform-specific implementation instance.
  static ClickstreamAnalyticsPlusPlatform get _platform =>
      ClickstreamAnalyticsPlusPlatform.instance;

  /// Creates a new instance of [ClickstreamAnalyticsPlus].
  const ClickstreamAnalyticsPlus();

  /// Initializes the Clickstream Analytics SDK.
  ///
  /// Returns `true` if initialization was successful, otherwise `false`.
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

  /// Records an analytics event with the given [name] and optional [attributes].
  Future<void> recordEvent(String name, {Map<String, dynamic>? attributes}) =>
      _platform.recordEvent(name, attributes: attributes);

  /// Sets the user ID for analytics tracking.
  Future<void> setUserId(String userId) => _platform.setUserId(userId);

  /// Sets user attributes for analytics tracking.
  Future<void> setUserAttributes(Map<String, dynamic> attributes) =>
      _platform.setUserAttributes(attributes);

  /// Sets global attributes for all analytics events.
  Future<void> setGlobalAttributes(Map<String, dynamic> attributes) =>
      _platform.setGlobalAttributes(attributes);

  /// Removes a global attribute by [key].
  Future<void> removeGlobalAttribute(String key) =>
      _platform.removeGlobalAttribute(key);

  /// Pauses the current analytics session.
  Future<void> pauseSession() => _platform.pauseSession();

  /// Resumes the current analytics session.
  Future<void> resumeSession() => _platform.resumeSession();

  /// Enables or disables logging for the analytics SDK.
  Future<void> enableLogging(bool enabled) => _platform.enableLogging(enabled);

  /// Gets the SDK version from the native platform.
  Future<String?> getSdkVersion() => _platform.getSdkVersion();

  /// Flushes all queued analytics events to the backend.
  Future<void> flushEvents() => _platform.flushEvents();
}
