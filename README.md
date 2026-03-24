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


## 🍏 iOS / macOS Integration Guide

### Why SPM Is Required

This plugin depends on the [AWS Clickstream Swift SDK](https://github.com/aws-solutions-library-samples/clickstream-analytics-on-aws-swift-sdk), which in turn depends on **AWS Amplify v2 for Swift**. Both are distributed **exclusively via Swift Package Manager (SPM)** — they are not available on CocoaPods or Carthage.

The `.podspec` files included in this plugin are stubs that satisfy Flutter's CocoaPods tooling. They do not pull in the Clickstream native SDK — that resolution happens through the `Package.swift` manifests.

### Dual Integration: CocoaPods + SPM Side by Side

Most existing Flutter apps use CocoaPods for other dependencies (Firebase, Google Maps, etc.). **Flutter 3.24+ supports CocoaPods and SPM running side by side** in the same project. This is the expected setup — you do not need to migrate away from CocoaPods.

When both are active:
- **CocoaPods** continues to manage pods listed in your `Podfile` (including the Flutter engine).
- **SPM** handles packages declared via `Package.swift` manifests in plugins (like this plugin's Clickstream SDK dependency).
- Xcode resolves both dependency graphs independently — they coexist without conflict.

### Setup for Existing CocoaPods Projects

**Prerequisites:** Flutter 3.24+, Xcode 15+, Swift 5.9+.

**Step 1 — Enable SPM in Flutter:**

```bash
flutter config --enable-swift-package-manager
```

Verify with `flutter config` — you should see `enable-swift-package-manager: true`.

**Step 2 — Add the plugin and rebuild:**

```bash
flutter pub add clickstream_analytics_plus
flutter build ios   # or: flutter build macos
```

On the first build after enabling SPM, Flutter will:
1. Keep your existing `Podfile` and `Pods/` directory untouched.
2. Generate a `FlutterGeneratedPluginSwiftPackage` inside `ios/Flutter/ephemeral/Packages/`.
3. Add an SPM package reference in the Xcode project, which pulls the Clickstream SDK and Amplify via SPM.
4. Create or update `Package.resolved` at the workspace level with pinned SPM dependency versions.

**Your `Podfile` stays the same.** No manual changes needed.

**Step 3 — Commit the project changes:**

After the first successful build, you'll see changes in:

```
ios/Runner.xcodeproj/project.pbxproj   # Now references the SPM package
ios/Flutter/Debug.xcconfig              # CocoaPods include added
ios/Flutter/Release.xcconfig            # CocoaPods include added
```

> **Note:** `Package.resolved` files are generated lock files. You can gitignore them (this plugin does) or commit them for reproducible builds — either approach works.

### New Projects (SPM-Only)

For greenfield projects, you can skip CocoaPods entirely:

```bash
flutter config --enable-swift-package-manager
flutter create --platforms=ios,macos my_app
cd my_app
flutter pub add clickstream_analytics_plus
flutter run
```

### Deployment Targets

The minimum deployment targets required by the Clickstream Swift SDK:

| Platform | Minimum Version |
|----------|:-:|
| iOS      | 13.0 |
| macOS    | 10.15 |

If your project sets a lower target, you'll get build errors. Update accordingly:

- **Podfile (iOS):** `platform :ios, '13.0'`
- **Podfile (macOS):** `platform :osx, '10.15'`
- **Xcode:** Set "Minimum Deployments" in the Runner target's General tab.

### CI/CD Considerations

**Xcode version:** Use Xcode 15+ (SPM resolution requires Swift 5.9+).

**SPM package resolution:** The first build downloads the full SPM dependency graph (Amplify, AWS SDK for Swift, Starscream, SQLite.swift, etc.) which can take 2–5 minutes. Cache the SPM SourcePackages directory to speed up subsequent builds.

**Example (GitHub Actions):**

```yaml
- name: Cache CocoaPods
  uses: actions/cache@v4
  with:
    path: ios/Pods
    key: pods-${{ hashFiles('ios/Podfile.lock') }}

- name: Cache SPM packages
  uses: actions/cache@v4
  with:
    path: build/ios/SourcePackages
    key: spm-${{ hashFiles('**/Package.resolved') }}
```

**Common CI gotchas:**

| Issue | Fix |
|-------|-----|
| SPM resolution timeouts | Ensure outbound HTTPS to `github.com` is allowed. Pre-warm the SPM cache. |
| `xcode-select` points to CLI tools only | Point it to full Xcode: `sudo xcode-select -s /Applications/Xcode.app` |
| Parallel jobs with shared derived-data | Use separate derived-data paths per job, or serialize SPM resolution. |

### Troubleshooting

**"Unable to find module dependency: 'Clickstream'"**

SPM is not enabled or did not resolve the Clickstream SDK.

1. Verify: `flutter config` should show `enable-swift-package-manager: true`.
2. Clean rebuild: `flutter clean && flutter pub get && flutter build ios`.
3. Open `ios/Runner.xcworkspace` in Xcode → **File > Packages** — you should see `clickstream-analytics-on-aws-swift-sdk` listed.

**Deployment target too low**

```
The package product 'Clickstream' requires minimum platform version 13.0
```

Set iOS to 13.0+ / macOS to 10.15+ in your Podfile and Xcode project settings. Run `pod install`, then rebuild.

**`Package.resolved` merge conflicts**

Accept either version, then run `flutter build ios` to let SPM re-resolve.

**"Package resolution failed" or "cannot clone repository"**

SPM needs network access to clone repos from GitHub. Check network/proxy settings. Behind a corporate proxy:

```bash
git config --global http.proxy http://your-proxy:port
```

**Build fails after upgrading Flutter or Xcode**

Full clean rebuild:

```bash
flutter clean
rm -rf ios/Pods ios/Podfile.lock
rm -rf build/
flutter pub get
cd ios && pod install && cd ..
flutter build ios
```

For more details, see the [Flutter SPM guide for app developers](https://docs.flutter.dev/packages-and-plugins/swift-package-manager/for-app-developers).

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
| iOS | ✅ Supported (via Swift SDK / SPM) | ✅ Supported (vendored CocoaPods) |
| macOS | ✅ Supported | ❌ Not Supported |
| Web | ✅ Supported | ❌ Not Supported |
| Linux / Windows | 🧩 Planned | ❌ Not Supported |
| Session Lifecycle | ✅ Integrated with AppLifecycle | ⚠️ Manual only |
| Federated Plugin Architecture | ✅ Yes | ❌ No |
| Example App | ✅ Multi-tab demo | ✅ Basic example |
| Build Integration | ✅ SPM + Gradle (modern) | Vendored CocoaPods + Gradle |
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
