import UIKit
import Flutter
import CoreLocation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let methodChannel = FlutterMethodChannel(name: "modi/deviceInfo",
                                              binaryMessenger: controller.binaryMessenger)
    methodChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        if(call.method == "getDeviceInfo"){
            let version = UIDevice.current.systemVersion
            let modelName = UIDevice.current.model
            result(String(modelName+" "+version))
        } else {
            result(String("Unknown method name"))
        }
    })
    
    let eventsChannel = FlutterEventChannel(name: "locationStatusStream",
                                              binaryMessenger: controller.binaryMessenger)

    eventsChannel.setStreamHandler(SwiftStreamHandler())
    
   

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
class SwiftStreamHandler: NSObject, FlutterStreamHandler {
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        events(Reachability.isLocationServiceEnabled())
         return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }
}


open class Reachability {
    class func isLocationServiceEnabled() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
                case .notDetermined, .restricted, .denied:
                return false
                case .authorizedAlways, .authorizedWhenInUse:
                return true
                default:
                print("Something wrong with Location services")
                return false
            }
        } else {
                print("Location services are not enabled")
                return false
          }
        }
     }
