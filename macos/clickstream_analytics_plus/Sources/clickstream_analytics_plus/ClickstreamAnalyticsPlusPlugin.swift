import Cocoa
import FlutterMacOS
import Clickstream

public class ClickstreamAnalyticsPlusPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "clickstream_analytics_plus", binaryMessenger: registrar.messenger)
    let instance = ClickstreamAnalyticsPlusPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "initialize":
      guard let args = call.arguments as? [String: Any],
            let appId = args["appId"] as? String,
            let endpoint = args["endpoint"] as? String else {
        result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing appId or endpoint", details: nil))
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
          _ = configuration.withSessionTimeoutDuration(sessionTimeoutMs)
        }
        if let sendEventIntervalMs = args["sendEventIntervalMs"] as? Int {
          _ = configuration.withSendEventInterval(sendEventIntervalMs)
        }
        if let initialGlobal = args["initialGlobalAttributes"] as? [String: Any] {
          _ = configuration.withInitialGlobalAttributes(self.makeAttributes(initialGlobal))
        }

        try ClickstreamAnalytics.initSDK(configuration)
        DispatchQueue.main.async { result(true) }
      } catch {
        result(FlutterError(code: "INIT_ERROR", message: "Failed to initialize ClickstreamAnalytics: \(error)", details: nil))
      }
    case "pauseSession":
      ClickstreamAnalytics.pauseSession()
      result(nil)
    case "resumeSession":
      ClickstreamAnalytics.resumeSession()
      result(nil)
    case "setGlobalAttributes":
      if let args = call.arguments as? [String: Any],
         let attributes = args["attributes"] as? [String: Any] {
        ClickstreamAnalytics.addGlobalAttributes(self.makeAttributes(attributes))
      }
      result(nil)
    case "removeGlobalAttribute":
      if let args = call.arguments as? [String: Any],
         let key = args["key"] as? String {
        ClickstreamAnalytics.removeGlobalAttribute(key)
      }
      result(nil)
    case "enableLogging":
      // Not supported as a runtime toggle; configure via init.
      result(nil)
    case "reset":
      ClickstreamAnalytics.reset()
      result(nil)
    case "getSdkVersion":
      result(ClickstreamAnalytics.getSDKVersion())
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
    let attrsDict = arguments["attributes"] as? [String: Any] ?? [:]
    let attrs = makeAttributes(attrsDict)
    ClickstreamAnalytics.recordEvent(name, attrs)
  }

  func setUserAttributes(_ arguments: [String: Any]) {
    if let dict = arguments["attributes"] as? [String: Any] {
      ClickstreamAnalytics.addUserAttributes(makeAttributes(dict))
    }
  }

  func makeAttributes(_ dict: [String: Any]) -> ClickstreamAttribute {
      let builder = ClickstreamAttribute()
      dict.forEach { (key, value) in
          switch value {
          case let s as String:
              builder.add(key, s)
          case let b as Bool:
              builder.add(key, b)
          case let i as Int:
              builder.add(key, i)
          case let d as Double:
              builder.add(key, d)
          default:
              builder.add(key, String(describing: value))
          }
      }
      return builder
  }
}

