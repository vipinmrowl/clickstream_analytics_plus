## 0.0.5
- Cleaned up iOS/macOS podspecs with accurate metadata (author, homepage, version, descriptions)
- Enabled PrivacyInfo.xcprivacy resource bundles in both iOS and macOS podspecs
- Bumped macOS podspec minimum deployment target from 10.11 to 10.15 (matches Package.swift)
- Bumped minimum Flutter version to 3.24.0 (required for native SPM support)
- Added clear documentation that SPM is required (Clickstream SDK + Amplify v2 are SPM-only, not on CocoaPods)
- Removed checked-in Package.resolved files and added them to .gitignore
- Updated README: modernized iOS/macOS requirements section, updated comparison table
- Added comprehensive integration guide: dual CocoaPods+SPM setup, CI/CD caching, troubleshooting

## 0.0.1
- Initial release with Android, iOS, macOS, and Web support.
- Federated plugin architecture.
- Multi-tab sample app included.

## 0.0.2
- Added improvements to platform flexibility and stability.
- Removed risky `reset()` functionality.

## 0.0.3
- Better documentation
- Deprecated use of js_util and the js package in favor of js interop
- Updated packages
- Readme updated to include notes on enabling and disabling SPM

## 0.0.4
- Handles conflict when used with Amplify plugins. Hot restarts would cause reinitialization and fail, happens only on IOS/Macos