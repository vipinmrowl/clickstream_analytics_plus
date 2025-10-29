
import 'clickstream_analytics_plus_platform_interface.dart';

class ClickstreamAnalyticsPlus {
  Future<String?> getPlatformVersion() {
    return ClickstreamAnalyticsPlusPlatform.instance.getPlatformVersion();
  }
}
