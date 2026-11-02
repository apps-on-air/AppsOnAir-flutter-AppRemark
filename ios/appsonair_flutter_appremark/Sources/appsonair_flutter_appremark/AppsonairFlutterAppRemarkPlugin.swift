import Flutter
import UIKit
import AppsOnAir_AppRemark

public class AppsonairFlutterAppremarkPlugin: NSObject, FlutterPlugin {
    static var channel:FlutterMethodChannel = FlutterMethodChannel()
    
    static var eventChannel: FlutterEventChannel = FlutterEventChannel()
    static var eventSink: FlutterEventSink?
    
    public override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(self.onViewVisibilityChanged(_:)), name: .visibilityChanges, object: nil)
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        self.channel = FlutterMethodChannel(name: "appsOnAirAppRemark", binaryMessenger: registrar.messenger())
      
        let instance = AppsonairFlutterAppremarkPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        self.eventChannel = FlutterEventChannel(name: "appsOnAirAppRemark/events", binaryMessenger: registrar.messenger())
        self.eventChannel.setStreamHandler(instance)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "initializeAppRemark":
            guard let appsOnAirAppId = (Bundle.main.object(forInfoDictionaryKey: "AppsonairAppId") as? String
                                     ?? Bundle.main.object(forInfoDictionaryKey: "AppsOnAirAPIKey") as? String) else {
                result(["error": "AppsonairAppId not found in Info.plist"])
                return
            }
            guard let args = call.arguments as? Dictionary<String, Any>,
                  let directoryData = args["options"] as? NSDictionary,
                  let shakeGestureEnable = args["shakeGestureEnable"] as? Bool else {
                result(false)
                return
            }
            let shakeSensitivity: ShakeSensitivity? = {
                switch args["shakeSensitivity"] as? String {
                case "veryLow":  return .veryLow
                case "low":      return .low
                case "medium":   return .medium
                case "high":     return .high
                case "veryHigh": return .veryHigh
                default:         return nil
                }
            }()
            do {
                AppRemarkService.shared.initialize(shakeGestureEnable: shakeGestureEnable, options: directoryData, shakeSensitivity: shakeSensitivity ?? .medium) { remarks in
                    DispatchQueue.main.async {
                        if let jsonData = try? JSONSerialization.data(withJSONObject: remarks, options: []),
                           let jsonString = String(data: jsonData, encoding: .utf8) {
                            AppsonairFlutterAppremarkPlugin.eventSink?(jsonString)
                        }
                    }
                }
                if Bundle.main.object(forInfoDictionaryKey: "NSPhotoLibraryUsageDescription") is String {
                    result(true)
                } else {
                    result(["error": "NSPhotoLibraryUsageDescription not found in Info.plist"])
                }
            } catch let error {
                print("Failed to load: \(error.localizedDescription)")
                result(false)
            }

        case "addAppRemark":
            do {
                AppRemarkService.shared.addRemark()
                result(true)
            } catch let error {
                print("Failed to load: \(error.localizedDescription)")
                result(false)
            }

        case "setAdditionalMetaData":
            let args = call.arguments as? Dictionary<String, Any> ?? [:]
            let directoryData = args["extraPayload"] as? NSDictionary ?? [:]
            do {
                AppRemarkService.shared.setAdditionalMetaData(extraPayload: directoryData)
                result(true)
            } catch let error {
                print("Failed to load: \(error.localizedDescription)")
                result(false)
            }

        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    
    @objc public func onViewVisibilityChanged(_ notification: NSNotification) {
        if let isPresented = notification.userInfo?["isPresented"] as? Bool {
            if(isPresented == true) {
                AppsonairFlutterAppremarkPlugin.channel.invokeMethod("openDialog", arguments:true)
            } else {
                AppsonairFlutterAppremarkPlugin.channel.invokeMethod("closeDialog", arguments:true)
            }
        }
    }
    deinit {
         NotificationCenter.default.removeObserver(self, name: .visibilityChanges, object: nil)
    }
}

extension AppsonairFlutterAppremarkPlugin: FlutterStreamHandler {
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        AppsonairFlutterAppremarkPlugin.eventSink = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        AppsonairFlutterAppremarkPlugin.eventSink = nil
        return nil
    }
}

extension Notification.Name {
 static let visibilityChanges = NSNotification.Name("visibilityChanges")
}
