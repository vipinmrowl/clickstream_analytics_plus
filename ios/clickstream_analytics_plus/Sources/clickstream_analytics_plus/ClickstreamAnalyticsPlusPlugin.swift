import Flutter
import UIKit
import Clickstream


/// Flutter plugin for Clickstream Analytics on iOS/macOS.
public class ClickstreamAnalyticsPlusPlugin: NSObject, FlutterPlugin {
  private static var hasInitialized = false // Track initialization state across Dart restarts

  /// Registers the plugin with the Flutter engine.
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "clickstream_analytics_plus", binaryMessenger: registrar.messenger())
    let instance = ClickstreamAnalyticsPlusPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  /// Handles method calls from Dart to the native plugin.
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "initialize":
      // Initializes the Clickstream SDK with provided arguments.
      guard let args = call.arguments as? [String: Any],
            let appId = args["appId"] as? String,
            let endpoint = args["endpoint"] as? String else {
        result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing appId or endpoint", details: nil))
        return
      }

      // ✅ Guard against double initialization (survives hot restart)
      if Self.hasInitialized {
        print("⚠️ ClickstreamAnalytics already initialized — skipping.")
        result(true)
        return
      }

      do {
        let configuration = ClickstreamConfiguration()
          .withAppId(appId)
          .withEndpoint(endpoint)

        if let logEvents = args["logEvents"] as? Bool {
          _ = configuration.withLogEvents(logEvents)
        }
        if let compressEvents = args["compressEvents"] as? Bool {
          _ = configuration.withCompressEvents(compressEvents)
        }
        if let sessionTimeoutMs = args["sessionTimeoutMs"] as? Int {
          _ = configuration.withSessionTimeoutDuration(Int64(sessionTimeoutMs))
        }
        if let sendEventIntervalMs = args["sendEventIntervalMs"] as? Int {
          _ = configuration.withSendEventInterval(sendEventIntervalMs)
        }
        if let initialGlobal = args["initialGlobalAttributes"] as? [String: Any] {
          _ = configuration.withInitialGlobalAttributes(self.makeAttributes(initialGlobal))
        }

        try ClickstreamAnalytics.initSDK(configuration)
        print("✅ ClickstreamAnalytics initialized successfully with appId=\(appId)")
        Self.hasInitialized = true  // ✅ remember across Dart restarts
        DispatchQueue.main.async { result(true) }
      } catch {
        // If already initialized, just treat as success
        if "\(error)".contains("Amplify.configure") {
          print("⚠️ ClickstreamAnalytics already configured, ignoring.")
          Self.hasInitialized = true
          result(true)
        } else {
          result(FlutterError(code: "INIT_ERROR",
                              message: "Failed to initialize ClickstreamAnalytics: \(error)",
                              details: nil))
        }
      }

    case "setGlobalAttributes":
      // Sets global attributes for all events.
      if let args = call.arguments as? [String: Any],
         let attributes = args["attributes"] as? [String: Any] {
        ClickstreamAnalytics.addGlobalAttributes(self.makeAttributes(attributes))
      }
      result(nil)
    case "pauseSession", "resumeSession":
      // Session management is automatic; no-op
      result(nil)
    case "removeGlobalAttribute":
      // SDK does not expose this directly
      result(nil)
    case "flushEvents":
      // Flushes all queued events.
      ClickstreamAnalytics.flushEvents()
      result(nil)
    case "getSdkVersion":
      // Returns the SDK version (not exposed by native SDK).
      result("iOS/macOS Clickstream SDK - version not exposed")
    case "enableLogging":
      // Not supported as a runtime toggle; configure via init.
      result(nil)
    case "recordEvent":
      // Records an analytics event.
      recordEvent(call.arguments as! [String: Any])
      result(nil)
    case "setUserId":
      // Sets the user ID for analytics tracking.
      setUserId(call.arguments as! [String: Any])
      result(nil)
    case "setUserAttributes":
      // Sets user attributes for analytics tracking.
      setUserAttributes(call.arguments as! [String: Any])
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }


  /// Initializes the Clickstream SDK with a default configuration (legacy helper).
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

 


  /// Sets the user ID for analytics tracking.
  func setUserId(_ arguments: [String: Any]) {
    if arguments["userId"] is NSNull {
      ClickstreamAnalytics.setUserId(nil)
    } else {
      ClickstreamAnalytics.setUserId(arguments["userId"] as? String)
    }
  }



  /// Records an analytics event with the given name and attributes.
  func recordEvent(_ arguments: [String: Any]) {
    let name = arguments["name"] as! String
    let attrsDict = arguments["attributes"] as? [String: Any] ?? [:]
    let attrs = makeAttributes(attrsDict)
    ClickstreamAnalytics.recordEvent(name, attrs)
  }


  /// Sets user attributes for analytics tracking.
  func setUserAttributes(_ arguments: [String: Any]) {
    if let dict = arguments["attributes"] as? [String: Any] {
      ClickstreamAnalytics.addUserAttributes(makeAttributes(dict))
    }
  }

  /// Converts a [String: Any] dictionary to a ClickstreamAttribute.
  func makeAttributes(_ dict: [String: Any]) -> ClickstreamAttribute {
    var attributes: ClickstreamAttribute = [:]
    dict.forEach { (key, value) in
      if let s = value as? String {
        attributes[key] = s
      } else if let b = value as? Bool {
        attributes[key] = b
      } else if let i = value as? Int {
        attributes[key] = i
      } else if let d = value as? Double {
        attributes[key] = d
      } else {
        attributes[key] = String(describing: value)
      }
    }
    return attributes
  }
}

