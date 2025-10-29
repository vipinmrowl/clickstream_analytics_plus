// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "clickstream_analytics_plus",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "clickstream-analytics-plus", targets: ["clickstream_analytics_plus"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/aws-solutions-library-samples/clickstream-analytics-on-aws-swift-sdk.git",
            from: "0.12.6"
        )
    ],
    targets: [
        .target(
            name: "clickstream_analytics_plus",
            dependencies: [
                .product(
                    name: "Clickstream",
                    package: "clickstream-analytics-on-aws-swift-sdk"
                )
            ],
            path: "Sources/clickstream_analytics_plus",
            resources: [
                // If your plugin requires a privacy manifest, for example if it uses any required
                // reason APIs, update the PrivacyInfo.xcprivacy file to describe your plugin's
                // privacy impact, and then uncomment these lines. For more information, see
                // https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
                .process("PrivacyInfo.xcprivacy"),

                // If you have other resources that need to be bundled with your plugin, refer to
                // the following instructions to add them:
                // https://developer.apple.com/documentation/xcode/bundling-resources-with-a-swift-package
            ]
        )
    ]
)
