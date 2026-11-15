import Flutter
import StoreKit
import UIKit

@objc class SceneDelegate: FlutterSceneDelegate {
  private var reviewChannel: FlutterMethodChannel?

  override func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    super.scene(scene, willConnectTo: session, options: connectionOptions)

    guard let controller = window?.rootViewController as? FlutterViewController else {
      return
    }

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
