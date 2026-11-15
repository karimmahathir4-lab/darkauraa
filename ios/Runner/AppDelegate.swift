import Flutter
import StoreKit
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    if let controller = window?.rootViewController as? FlutterViewController {
      let reviewChannel = FlutterMethodChannel(
        name: "com.handcraft.darkaura/review",
        binaryMessenger: controller.binaryMessenger
      )
      reviewChannel.setMethodCallHandler { call, result in
        guard call.method == "requestReview" else {
          result(FlutterMethodNotImplemented)
          return
        }

        guard #available(iOS 18.0, *),
              let scene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first(where: { $0.activationState == .foregroundActive }) else {
          result(false)
          return
        }

        AppStore.requestReview(in: scene)
        result(true)
      }
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
