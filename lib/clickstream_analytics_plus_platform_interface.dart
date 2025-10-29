import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'clickstream_analytics_plus_method_channel.dart';

abstract class ClickstreamAnalyticsPlusPlatform extends PlatformInterface {
  /// Constructs a ClickstreamAnalyticsPlusPlatform.
  ClickstreamAnalyticsPlusPlatform() : super(token: _token);

  static final Object _token = Object();

  static ClickstreamAnalyticsPlusPlatform _instance = MethodChannelClickstreamAnalyticsPlus();

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

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
