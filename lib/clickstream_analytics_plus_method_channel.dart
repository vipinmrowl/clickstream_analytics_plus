import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'clickstream_analytics_plus_platform_interface.dart';

/// An implementation of [ClickstreamAnalyticsPlusPlatform] that uses method channels.
class MethodChannelClickstreamAnalyticsPlus extends ClickstreamAnalyticsPlusPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('clickstream_analytics_plus');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
