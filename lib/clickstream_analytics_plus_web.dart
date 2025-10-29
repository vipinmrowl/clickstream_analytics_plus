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
}

class ClickstreamAnalyticsPlusWeb extends ClickstreamAnalyticsPlusPlatform {
  static void registerWith(Registrar registrar) {
    ClickstreamAnalyticsPlusPlatform.instance = ClickstreamAnalyticsPlusWeb();
  }

  @override
  Future<bool> initialize({
    required String appId,
    required String endpoint,
  }) async {
    clickstreamAnalytics?.initialize(appId, endpoint);
    return true;
  }

  @override
  Future<void> recordEvent(
    String name, {
    Map<String, dynamic>? attributes,
  }) async {
    final jsAttributes = attributes != null ? js_util.jsify(attributes) : null;
    clickstreamAnalytics?.recordEvent(name, jsAttributes);
  }

  @override
  Future<void> setUserId(String userId) async {
    clickstreamAnalytics?.setUserId(userId);
  }

  @override
  Future<void> setUserAttributes(Map<String, String> attributes) async {
    clickstreamAnalytics?.setUserAttributes(js_util.jsify(attributes));
  }

  @override
  Future<void> flushEvents() async {
    clickstreamAnalytics?.flushEvents();
  }
}
