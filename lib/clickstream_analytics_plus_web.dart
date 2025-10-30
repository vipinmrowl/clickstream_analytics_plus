// ignore: avoid_web_libraries_in_flutter
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'dart:js_util' as js_util;
import 'package:js/js.dart';
import 'clickstream_analytics_plus_platform_interface.dart';

// JS interop for AWS Clickstream Web SDK
@JS('clickstreamAnalytics')
external ClickstreamAnalyticsJS? get clickstreamAnalytics;

@JS()
@anonymous
class ClickstreamAnalyticsJS {
  external void initialize(String appId, String endpoint);
  external void recordEvent(String name, dynamic attributes);
  external void setUserId(String userId);
  external void setUserAttributes(dynamic attributes);
  external void flushEvents();
  external void pauseSession();
  external void resumeSession();
  external void setGlobalAttributes(dynamic attributes);
  external void removeGlobalAttribute(String key);
  external String getSDKVersion();
  external void reset();
}

/// Web implementation of [ClickstreamAnalyticsPlusPlatform] using JS interop.
class ClickstreamAnalyticsPlusWeb extends ClickstreamAnalyticsPlusPlatform {
  /// Registers the web implementation with the Flutter plugin registrar.
  static void registerWith(Registrar registrar) {
    ClickstreamAnalyticsPlusPlatform.instance = ClickstreamAnalyticsPlusWeb();
  }

  /// Initializes the Clickstream Analytics SDK on the web platform.
  ///
  /// Returns `true` if initialization was successful.
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
    // Try to pass an options object if the Web SDK supports it; otherwise fall back.
    final options = {
      if (logEvents != null) 'logEvents': logEvents,
      if (compressEvents != null) 'compressEvents': compressEvents,
      if (sessionTimeoutMs != null) 'sessionTimeoutMs': sessionTimeoutMs,
      if (sendEventIntervalMs != null)
        'sendEventIntervalMs': sendEventIntervalMs,
      if (initialGlobalAttributes != null)
        'initialGlobalAttributes': initialGlobalAttributes,
    };
    if (options.isEmpty) {
      clickstreamAnalytics?.initialize(appId, endpoint);
    } else {
      // Some builds expose initialize(appId, endpoint, options)
      try {
        js_util.callMethod(clickstreamAnalytics as Object, 'initialize', [
          appId,
          endpoint,
          js_util.jsify(options),
        ]);
      } catch (_) {
        clickstreamAnalytics?.initialize(appId, endpoint);
      }
    }
    return true;
  }

  /// Records an analytics event with the given [name] and optional [attributes].
  @override
  Future<void> recordEvent(
    String name, {
    Map<String, dynamic>? attributes,
  }) async {
    final jsAttributes = attributes != null ? js_util.jsify(attributes) : null;
    clickstreamAnalytics?.recordEvent(name, jsAttributes);
  }

  /// Sets the user ID for analytics tracking.
  @override
  Future<void> setUserId(String userId) async {
    clickstreamAnalytics?.setUserId(userId);
  }

  /// Sets user attributes for analytics tracking.
  @override
  Future<void> setUserAttributes(Map<String, dynamic> attributes) async {
    clickstreamAnalytics?.setUserAttributes(js_util.jsify(attributes));
  }

  /// Flushes all queued analytics events to the backend.
  @override
  Future<void> flushEvents() async {
    clickstreamAnalytics?.flushEvents();
  }

  /// Pauses the current analytics session.
  @override
  Future<void> pauseSession() async {
    try {
      clickstreamAnalytics?.pauseSession();
    } catch (_) {}
  }

  /// Resumes the current analytics session.
  @override
  Future<void> resumeSession() async {
    try {
      clickstreamAnalytics?.resumeSession();
    } catch (_) {}
  }

  /// Sets global attributes for all analytics events.
  @override
  Future<void> setGlobalAttributes(Map<String, dynamic> attributes) async {
    try {
      clickstreamAnalytics?.setGlobalAttributes(js_util.jsify(attributes));
    } catch (_) {}
  }

  /// Removes a global attribute by [key].
  @override
  Future<void> removeGlobalAttribute(String key) async {
    try {
      clickstreamAnalytics?.removeGlobalAttribute(key);
    } catch (_) {}
  }

  /// Enables or disables logging for the analytics SDK. (No-op on web.)
  @override
  Future<void> enableLogging(bool enabled) async {
    // Web SDK typically config-only; safe to ignore at runtime.
  }

  /// Gets the SDK version from the web Clickstream SDK, if available.
  @override
  Future<String?> getSdkVersion() async {
    try {
      final v = js_util.callMethod(
        clickstreamAnalytics as Object,
        'getSDKVersion',
        [],
      );
      return v?.toString();
    } catch (_) {
      return 'Web Clickstream SDK - version not exposed';
    }
  }
}
