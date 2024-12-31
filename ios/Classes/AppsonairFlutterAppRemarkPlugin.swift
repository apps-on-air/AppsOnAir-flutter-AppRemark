import Flutter
import UIKit
import AppsOnAir_AppRemark

public class AppsonairFlutterAppremarkPlugin: NSObject, FlutterPlugin {
    static var channel:FlutterMethodChannel = FlutterMethodChannel()
    
    public override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(self.onViewVisibilityChanged(_:)), name: .visibilityChanges, object: nil)
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        self.channel = FlutterMethodChannel(name: "appsOnAirAppRemark", binaryMessenger: registrar.messenger())
      
        let instance = AppsonairFlutterAppremarkPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if("initializeAppRemark" == call.method) {
            if let appsOnAirAPIKey = Bundle.main.object(forInfoDictionaryKey: "AppsOnAirAPIKey") as? String {
              if let args = call.arguments as? Dictionary<String, Any>,
                let directoryData = args["options"] as? NSDictionary, let shakeGestureEnable  = args["shakeGestureEnable"] as? Bool {
                    do{
                        AppRemarkService.shared.initialize(options: directoryData,shakeGestureEnable: shakeGestureEnable)
                       if let nsPhotoLibraryUsageDescription = Bundle.main.object(forInfoDictionaryKey: "NSPhotoLibraryUsageDescription") as? String {
                            result(true)
                        } else {
                            result(["error":"NSPhotoLibraryUsageDescription not found in Info.plist"])
                        }
                    }catch let error {
                        print("Failed to load: \(error.localizedDescription)")
                        result(false)
                    }
              }else {
                    result(false)
                }
            } else {
                result(["error":"AppsOnAir APIKey not found in Info.plist"])
            }
        } else if("addAppRemark" == call.method){
                  let args = call.arguments as? Dictionary<String, Any> ?? [:]
                  let directoryData = args["additionalData"] as? NSDictionary  ?? [:]
                        do{
                            AppRemarkService.shared.addRemark(extraPayload: directoryData)
                            result(true)
                        }catch let error {
                            print("Failed to load: \(error.localizedDescription)")
                            result(false)
                        }
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
extension Notification.Name {
 static let visibilityChanges = NSNotification.Name("visibilityChanges")
}

