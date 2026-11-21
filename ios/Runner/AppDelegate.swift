import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    if let controller = window?.rootViewController as? FlutterViewController {
      let iconChannel = FlutterMethodChannel(name: "com.handcraft.darkaura/app_icon", binaryMessenger: controller.binaryMessenger)
      iconChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
        switch call.method {
        case "supportsAlternateIcons":
          result(UIApplication.shared.supportsAlternateIcons)
        case "getAlternateIconName":
          result(UIApplication.shared.alternateIconName)
        case "setAlternateIconName":
          let iconName = call.arguments as? String
          // nil reverts to the primary (default) app icon
          let targetName = (iconName == nil || iconName?.isEmpty == true || iconName == "default") ? nil : iconName
          guard UIApplication.shared.supportsAlternateIcons else {
            result(FlutterError(code: "UNSUPPORTED", message: "Alternate icons not supported", details: nil))
            return
          }
          UIApplication.shared.setAlternateIconName(targetName) { error in
            if let error = error {
              result(FlutterError(code: "SET_ICON_FAILED", message: error.localizedDescription, details: nil))
            } else {
              result(true)
            }
          }
        default:
          result(FlutterMethodNotImplemented)
        }
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
