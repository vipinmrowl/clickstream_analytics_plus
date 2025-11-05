// ignore: dangling_library_doc_comments
/// Web implementation of Clickstream Analytics Plus using Dart static JS interop.
///
/// This file provides the web platform implementation for the Clickstream Analytics Plus plugin.
/// It uses Dart's static JS interop (dart:js_interop) to call the AWS Clickstream JS SDK
/// directly from Dart, without relying on package:js or dart:js_util.
///
/// All Dart maps/objects are converted to JS objects using the .jsify() extension from dart:js_interop_unsafe.
///
/// For more info on Dart JS interop, see:
///   https://dart.dev/web/js-interop
///   https://api.dart.dev/stable/dart-js_interop/dart-js_interop-library.html
///
/// Author: (your name or team)
/// Date: 2025-11-02
// ignore: avoid_web_libraries_in_flutter
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'clickstream_analytics_plus_platform_interface.dart';

/// JS interop binding to the global `window.clickstreamAnalytics` object.
@JS('clickstreamAnalytics')
external ClickstreamAnalyticsJS? get clickstreamAnalytics;

/// Static interop extension for the ClickstreamAnalyticsJS object.
/// Each method maps to a JS method on the analytics SDK.
extension type ClickstreamAnalyticsJS(JSObject _) implements JSObject {
  /// Calls JS: clickstreamAnalytics.initialize(appId, endpoint)
  external void initialize(String appId, String endpoint);

  /// Calls JS: clickstreamAnalytics.recordEvent(name, attributes)
  external void recordEvent(String name, JSAny attributes);

  /// Calls JS: clickstreamAnalytics.setUserId(userId)
  external void setUserId(String userId);

  /// Calls JS: clickstreamAnalytics.setUserAttributes(attributes)
  external void setUserAttributes(JSAny attributes);

  /// Calls JS: clickstreamAnalytics.flushEvents()
  external void flushEvents();

  /// Calls JS: clickstreamAnalytics.pauseSession()
  external void pauseSession();

  /// Calls JS: clickstreamAnalytics.resumeSession()
  external void resumeSession();

  /// Calls JS: clickstreamAnalytics.setGlobalAttributes(attributes)
  external void setGlobalAttributes(JSAny attributes);

  /// Calls JS: clickstreamAnalytics.removeGlobalAttribute(key)
  external void removeGlobalAttribute(String key);

  /// Calls JS: clickstreamAnalytics.getSDKVersion()
  external String getSDKVersion();

  /// Calls JS: clickstreamAnalytics.reset()
  external void reset();
}

/// Web platform implementation for Clickstream Analytics Plus.
///
/// Registers itself as the platform instance and delegates all analytics calls
/// to the JS SDK via static interop.
class ClickstreamAnalyticsPlusWeb extends ClickstreamAnalyticsPlusPlatform {
  /// Registers this web implementation with the Flutter plugin registrar.
  static void registerWith(Registrar registrar) {
    ClickstreamAnalyticsPlusPlatform.instance = ClickstreamAnalyticsPlusWeb();
  }

  /// Initializes the Clickstream Analytics SDK on the web platform.
  ///
  /// If options are provided, attempts to call the 3-argument JS initialize method.
  /// Otherwise, falls back to the 2-argument version.
  /// Returns `true` if initialization was attempted.
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
    final options = <String, dynamic>{
      if (logEvents != null) 'logEvents': logEvents,
      if (compressEvents != null) 'compressEvents': compressEvents,
      if (sessionTimeoutMs != null) 'sessionTimeoutMs': sessionTimeoutMs,
      if (sendEventIntervalMs != null)
        'sendEventIntervalMs': sendEventIntervalMs,
      if (initialGlobalAttributes != null)
        'initialGlobalAttributes': initialGlobalAttributes,
    };

    final jsOptions = options.isNotEmpty ? options.jsify() : null;

    try {
      if (jsOptions != null) {
        // Try to call the 3-argument initialize if available.
        final jsObj = clickstreamAnalytics as JSObject;
        final fn = jsObj.getProperty('initialize'.toJS) as JSFunction?;
        if (fn != null) {
          // callAsFunction takes a JS array of arguments.
          fn.callAsFunction(
            jsObj,
            [appId.toJS, endpoint.toJS, jsOptions].jsify()!,
          );
        } else {
          // Fallback to 2-argument version.
          clickstreamAnalytics?.initialize(appId, endpoint);
        }
      } else {
        clickstreamAnalytics?.initialize(appId, endpoint);
      }
    } catch (_) {
      // Always fallback to 2-argument version if anything fails.
      clickstreamAnalytics?.initialize(appId, endpoint);
    }
    return true;
  }

  /// Records an analytics event with the given [name] and optional [attributes].
  /// Calls the JS SDK's recordEvent method.
  @override
  Future<void> recordEvent(
    String name, {
    Map<String, dynamic>? attributes,
  }) async {
    final jsAttrs = (attributes ?? const {}).jsify();
    clickstreamAnalytics?.recordEvent(name, jsAttrs!);
  }

  /// Sets the user ID for analytics tracking.
  @override
  Future<void> setUserId(String userId) async {
    clickstreamAnalytics?.setUserId(userId);
  }

  /// Sets user attributes for analytics tracking.
  @override
  Future<void> setUserAttributes(Map<String, dynamic> attributes) async {
    final jsAttrs = attributes.jsify();
    clickstreamAnalytics?.setUserAttributes(jsAttrs!);
  }

  /// Flushes all queued analytics events to the backend.
  @override
  Future<void> flushEvents() async {
    clickstreamAnalytics?.flushEvents();
  }

  /// Pauses the current analytics session (no-op if unsupported).
  @override
  Future<void> pauseSession() async {
    try {
      clickstreamAnalytics?.pauseSession();
    } catch (_) {}
  }

  /// Resumes the current analytics session (no-op if unsupported).
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
      final jsAttrs = attributes.jsify();
      clickstreamAnalytics?.setGlobalAttributes(jsAttrs!);
    } catch (_) {}
  }

  /// Removes a global attribute by [key] (no-op if unsupported).
  @override
  Future<void> removeGlobalAttribute(String key) async {
    try {
      clickstreamAnalytics?.removeGlobalAttribute(key);
    } catch (_) {}
  }

  /// Enables or disables logging for the analytics SDK. (No-op on web.)
  @override
  Future<void> enableLogging(bool enabled) async {}

  /// Gets the SDK version from the web Clickstream SDK, if available.
  @override
  Future<String?> getSdkVersion() async {
    try {
      return clickstreamAnalytics?.getSDKVersion();
    } catch (_) {
      return 'Web Clickstream SDK - version not exposed';
    }
  }
}
