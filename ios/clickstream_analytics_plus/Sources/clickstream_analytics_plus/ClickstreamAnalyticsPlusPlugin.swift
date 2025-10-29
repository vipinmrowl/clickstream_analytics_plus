import Flutter
import UIKit
import Clickstream

public class ClickstreamAnalyticsPlusPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "clickstream_analytics_plus", binaryMessenger: registrar.messenger())
    let instance = ClickstreamAnalyticsPlusPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "initialize":
      guard let args = call.arguments as? [String: Any],
            let appId = args["appId"] as? String,
            let endpoint = args["endpoint"] as? String else {
        result(FlutterError(
          code: "INVALID_ARGUMENTS",
          message: "Missing appId or endpoint",
          details: nil
        ))
        return
      }

      do {
        let configuration = ClickstreamConfiguration()
          .withAppId(appId)
          .withEndpoint(endpoint)
          .withLogEvents(true)
          .withCompressEvents(true)
          .withSessionTimeoutDuration(1800000)
          .withInitialGlobalAttributes([
            ClickstreamAnalytics.Attr.TRAFFIC_SOURCE_SOURCE: "flutter"
          ])

        try ClickstreamAnalytics.initSDK(configuration)
        print("✅ Clickstream SDK initialized successfully for appId: \(appId)")

        // 🧠 Critical fix: respond back on main thread, after init finishes
        DispatchQueue.main.async {
          print("📤 Sending initialization success back to Flutter")
          result(true)
        }

      } catch {
        print("❌ Failed to initialize ClickstreamAnalytics: \(error)")
        result(FlutterError(
          code: "INIT_ERROR",
          message: "Failed to initialize ClickstreamAnalytics: \(error)",
          details: nil
        ))
      }
    case "recordEvent":
      recordEvent(call.arguments as! [String: Any])
      result(nil)
    case "setUserId":
      setUserId(call.arguments as! [String: Any])
      result(nil)
    case "setUserAttributes":
      setUserAttributes(call.arguments as! [String: Any])
      result(nil)
    case "flushEvents":
      ClickstreamAnalytics.flushEvents()
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  func initSDK(_ arguments: [String: Any]) -> Bool {
    do {
      let configuration = ClickstreamConfiguration()
        .withAppId(arguments["appId"] as! String)
        .withEndpoint(arguments["endpoint"] as! String)
        .withLogEvents(true)
        .withSendEventInterval(10000)
        .withSessionTimeoutDuration(1800000)
        .withCompressEvents(true)
        .withInitialGlobalAttributes([
          ClickstreamAnalytics.Attr.TRAFFIC_SOURCE_SOURCE: "flutter"
        ])

      try ClickstreamAnalytics.initSDK(configuration)
      return true
    } catch {
      print("❌ Failed to init ClickstreamAnalytics: \(error)")
      return false
    }
  }

 

  func setUserId(_ arguments: [String: Any]) {
    if arguments["userId"] is NSNull {
      ClickstreamAnalytics.setUserId(nil)
    } else {
      ClickstreamAnalytics.setUserId(arguments["userId"] as? String)
    }
  }


    func recordEvent(_ arguments: [String: Any]) {
    let name = arguments["name"] as! String
    let attrs = (arguments["attributes"] as? ClickstreamAttribute) ?? [:]
    ClickstreamAnalytics.recordEvent(name, attrs)
  }

  func setUserAttributes(_ arguments: [String: Any]) {
    if let attributes = arguments["attributes"] as? ClickstreamAttribute {
      ClickstreamAnalytics.addUserAttributes(attributes)
    }
  }
}

