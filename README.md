# 📊 clickstream_analytics_plus

**A modern Flutter plugin for AWS Clickstream Analytics**  
Supports **Android**, **iOS**, **macOS**, and **Web**, with a federated architecture for future platform extensions (Linux, Windows).

---

## 🧠 Overview

`clickstream_analytics_plus` is a **cross-platform Flutter plugin** that makes it easy to collect and send analytics events to [AWS Clickstream Analytics on AWS](https://github.com/aws-solutions/clickstream-analytics-on-aws).

It provides a **unified Flutter interface** wrapping the official native SDKs:

- **Android** → [AWS Clickstream Android SDK](https://github.com/aws-solutions-library-samples/clickstream-analytics-on-aws-android-sdk)  
- **iOS / macOS** → [AWS Clickstream Swift SDK](https://github.com/aws-solutions-library-samples/clickstream-analytics-on-aws-swift-sdk)  
- **Web** → [AWS Clickstream Web SDK](https://github.com/aws-solutions-library-samples/clickstream-analytics-on-aws-web-sdk)

This plugin enhances the original SDKs with:
- a **Dart-first API** (fully typed, null-safe)
- **session lifecycle integration** (pause/resume via AppLifecycleObserver)
- **multi-tab sample demo app**
- **macOS and Web support**, which are not available in the official plugin

---


## 🍏 Swift Package Manager (iOS/macOS)

To use this plugin on **iOS** or **macOS**, you must enable Swift Package Manager (SPM) support in your Flutter environment. This is required for integrating the AWS Clickstream Swift SDK via SPM.

Enable SPM with:

```bash
flutter config --enable-swift-package-manager
```

You can disable it later with:

```bash
flutter config --no-enable-swift-package-manager
```

See the [Flutter Swift Package Manager guide](https://docs.flutter.dev/packages-and-plugins/swift-package-manager/for-plugin-authors) for more details.

---

## 🧩 Installation

Add to your Flutter project:

```bash
flutter pub add clickstream_analytics_plus
```

Then rebuild your app:

```bash
flutter run
```

---

## 🚀 Quick Start

```dart
import 'package:clickstream_analytics_plus/clickstream_analytics_plus.dart';

final analytics = ClickstreamAnalyticsPlus();

Future<void> main() async {
  final ok = await analytics.initialize(
    appId: 'yourAppId',
    endpoint: 'https://example.com/collect',
    logEvents: true,
    compressEvents: true,
    sessionTimeoutMs: 1800000,
    sendEventIntervalMs: 10000,
    initialGlobalAttributes: {'platform': 'flutter'},
  );

  if (ok) {
    await analytics.setUserId('user_123');
    await analytics.recordEvent('app_start', attributes: {'screen': 'home'});
  }
}
```

---

## 🎯 Core API

### Initialization

```dart
await analytics.initialize(
  appId: 'myAppId',
  endpoint: 'https://your-endpoint.com/collect',
  logEvents: true,
  compressEvents: true,
  sessionTimeoutMs: 1800000,
  sendEventIntervalMs: 10000,
  initialGlobalAttributes: {'platform': 'flutter', 'build': 'demo'},
);
```

### Record Event

```dart
await analytics.recordEvent(
  'button_click',
  attributes: {
    'screen': 'home',
    'timestamp': DateTime.now().toIso8601String(),
  },
);
```

### Set User ID and Attributes

```dart
await analytics.setUserId('user123');
await analytics.setUserAttributes({'plan': 'pro', 'region': 'US'});
```

### Manage Global Attributes

```dart
await analytics.setGlobalAttributes({'platform': 'flutter'});
await analytics.removeGlobalAttribute('platform');
```

### Flush Events

```dart
await analytics.flushEvents();
```

### Check SDK Version

```dart
final version = await analytics.getSdkVersion();
```

---

## 🧱 Platform Coverage

| Feature / API               | Android | iOS | macOS | Web |
|-----------------------------|:-------:|:---:|:-----:|:---:|
| `initialize`                | ✅ | ✅ | ✅ | ✅ |
| `recordEvent`               | ✅ | ✅ | ✅ | ✅ |
| `setUserId`                 | ✅ | ✅ | ✅ | ✅ |
| `setUserAttributes`         | ✅ | ✅ | ✅ | ✅ |
| `flushEvents`               | ✅ | ✅ | ✅ | ✅ |
| `setGlobalAttributes`       | ✅ | ✅ | ✅ | ✅ |
| `removeGlobalAttribute`     | ⚠️ (stub) | ⚠️ (not exposed) | ✅ | ✅ |
| `pauseSession` / `resumeSession` | ⚠️ (auto) | ⚠️ (auto) | ✅ | ✅ |
| `getSdkVersion`             | ✅ (stub) | ✅ (stub) | ✅ | ✅ |

⚠️ *Some methods are safely stubbed where the native SDK does not expose direct APIs.*

---

## 💡 Example App

A full-featured **multi-tab example app** is included:
- **Home Tab** → Initialize & show SDK version  
- **Events Tab** → Record and flush events  
- **User Tab** → Update user/global attributes  

Run it with:

```bash
cd example
flutter run
```

---

## 🧰 Development

To build and format:

```bash
flutter pub get
dart format .
flutter analyze
```

To test Android:

```bash
cd example && flutter build apk
```

To test iOS/macOS:

```bash
cd example && flutter build ios
```

To test Web:

```bash
flutter run -d chrome
```

---

## 🛠 Architecture

This plugin follows the **Flutter Federated Plugin pattern**, with separate implementations for:
- `clickstream_analytics_plus_android`
- `clickstream_analytics_plus_ios`
- `clickstream_analytics_plus_macos`
- `clickstream_analytics_plus_web`

Future community contributions can extend this to **Windows** and **Linux**.

---

## 🔍 Comparison with Official AWS Plugin

| Feature | `clickstream_analytics_plus` | Official `clickstream_analytics` |
|----------|-----------------------------|----------------------------------|
| Maintainer | Community (Open Source) | AWS (Official) |
| Android | ✅ Supported | ✅ Supported |
| iOS | ✅ Supported (via Swift SDK / SPM) | ✅ Supported (CocoaPods only) |
| macOS | ✅ Supported | ❌ Not Supported |
| Web | ✅ Supported | ❌ Not Supported |
| Linux / Windows | 🧩 Planned | ❌ Not Supported |
| Session Lifecycle | ✅ Integrated with AppLifecycle | ⚠️ Manual only |
| Federated Plugin Architecture | ✅ Yes | ❌ No |
| Example App | ✅ Multi-tab demo | ✅ Basic example |
| Build Integration | ✅ SPM + Gradle | CocoaPods + Gradle |
| Logging Toggle | ✅ Via initialize params | ⚠️ Limited |
| License | Apache 2.0 | Apache 2.0 |

✅ **`clickstream_analytics_plus`** focuses on multi-platform support, developer flexibility, and an idiomatic Flutter API.  
It is not an official AWS package but a **community-maintained federated extension** built atop the same SDKs.

---

## ⚖️ License

Licensed under the [Apache 2.0 License](LICENSE).

---

## 🙌 Credits

This project is inspired by and wraps the official  
[AWS Clickstream Analytics SDKs](https://github.com/aws-solutions-library-samples)  
for Android, Swift, and Web.

Maintained independently by the Flutter community.
