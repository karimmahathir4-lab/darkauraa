import Flutter
import StoreKit
import UIKit

@objc class SceneDelegate: FlutterSceneDelegate {
  private var reviewChannel: FlutterMethodChannel?
  private var appIconChannel: FlutterMethodChannel?

  override func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    super.scene(scene, willConnectTo: session, options: connectionOptions)

    guard let controller = window?.rootViewController as? FlutterViewController else {
      return
    }

    let iconChannel = FlutterMethodChannel(
      name: "com.handcraft.darkaura/app_icon",
      binaryMessenger: controller.binaryMessenger
    )
    iconChannel.setMethodCallHandler { call, result in
      switch call.method {
      case "supportsAlternateIcons":
        result(UIApplication.shared.supportsAlternateIcons)
      case "getAlternateIconName":
        result(UIApplication.shared.alternateIconName)
      case "setAlternateIconName":
        let iconName = call.arguments as? String
        let targetName: String?
        if let iconName = iconName, !iconName.isEmpty, iconName != "default" {
          targetName = iconName
        } else {
          targetName = nil
        }
        guard UIApplication.shared.supportsAlternateIcons else {
          result(FlutterError(
            code: "UNSUPPORTED",
            message: "Alternate icons are not supported by this app.",
            details: nil
          ))
          return
        }
        UIApplication.shared.setAlternateIconName(targetName) { error in
          DispatchQueue.main.async {
            if let error = error {
              result(FlutterError(
                code: "SET_ICON_FAILED",
                message: error.localizedDescription,
                details: nil
              ))
            } else {
              result(true)
            }
          }
        }
      default:
        result(FlutterMethodNotImplemented)
      }
    }
    appIconChannel = iconChannel

    let channel = FlutterMethodChannel(
      name: "com.handcraft.darkaura/review",
      binaryMessenger: controller.binaryMessenger
    )
    channel.setMethodCallHandler { [weak self] call, result in
      guard call.method == "requestReview" else {
        result(FlutterMethodNotImplemented)
        return
      }

      guard #available(iOS 18.0, *),
            let windowScene = self?.window?.windowScene else {
        result(false)
        return
      }

      AppStore.requestReview(in: windowScene)
      result(true)
    }
    reviewChannel = channel
  }
}
