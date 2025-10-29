import 'package:flutter/services.dart';
import 'clickstream_analytics_plus_platform_interface.dart';

class MethodChannelClickstreamAnalyticsPlus
    extends ClickstreamAnalyticsPlusPlatform {
  static const MethodChannel _channel = MethodChannel(
    'clickstream_analytics_plus',
  );

  @override
  Future<bool> initialize({
    required String appId,
    required String endpoint,
  }) async {
    final result = await _channel.invokeMethod('initialize', {
      'appId': appId,
      'endpoint': endpoint,
    });

    // Handle iOS returning NSNumber(1)
    if (result == true || result == 1 || result?.toString() == 'true') {
      return true;
    }
    return false;
  }

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

  @override
  Future<void> setUserId(String userId) async {
    await _channel.invokeMethod('setUserId', {'userId': userId});
  }

  @override
  Future<void> setUserAttributes(Map<String, String> attributes) async {
    await _channel.invokeMethod('setUserAttributes', {
      'attributes': attributes,
    });
  }

  @override
  Future<void> flushEvents() async {
    await _channel.invokeMethod('flushEvents');
  }
}
