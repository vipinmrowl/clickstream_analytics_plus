#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint clickstream_analytics_plus.podspec` to validate before publishing.
#
# NOTE: This plugin requires Swift Package Manager (SPM) for the native
# AWS Clickstream Swift SDK dependency. The Clickstream SDK and its
# dependency (Amplify v2) are distributed exclusively via SPM and are
# NOT available on CocoaPods.
#
# Enable SPM in your Flutter project:
#   flutter config --enable-swift-package-manager
#
Pod::Spec.new do |s|
  s.name             = 'clickstream_analytics_plus'
  s.version          = '0.0.5'
  s.summary          = 'A Flutter plugin for AWS Clickstream Analytics.'
  s.description      = <<-DESC
A federated Flutter plugin for AWS Clickstream Analytics supporting Android, iOS, macOS, and Web.
Uses Swift Package Manager for the native AWS Clickstream Swift SDK dependency.
                       DESC
  s.homepage         = 'https://github.com/vipinmrowl/clickstream_analytics_plus'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Vipin Kashyap' => 'vipinkashyap2110@gmail.com' }

  s.source           = { :path => '.' }
  s.source_files = 'clickstream_analytics_plus/Sources/clickstream_analytics_plus/**/*'

  s.resource_bundles = {'clickstream_analytics_plus_privacy' => ['clickstream_analytics_plus/Sources/clickstream_analytics_plus/PrivacyInfo.xcprivacy']}

  s.dependency 'FlutterMacOS'

  s.platform = :osx, '10.15'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
