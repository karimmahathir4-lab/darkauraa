# Dark Aura Aim Panel

Dark Aura Aim Panel is a mobile FPS practice companion with an in-app setup checklist,
eight short aim drills, a five-mode aim trainer, saveable and shareable
practice profiles, sample device and sensitivity panels, original practice
lessons, and animated progress screens. Checklist preferences, lesson
completion, and drill history stay on the device. The app never reads or
changes game or phone settings. Device details and performance values are
simulated. The iPhone sensitivity catalog is a manual, locally saved demo
selector; its baseline is a heuristic starting point, not a game or Apple
recommendation. iPhone model and display references: [Apple iPhone model
identification](https://support.apple.com/en-asia/108044) and [Apple display
specifications](https://www.apple.com/iphone/compare/).

## Run

1. Create a Flutter project with `flutter create --project-name aura_red_aim_panel .`.
2. Replace `pubspec.yaml`, the `lib/` and `test/` directories, and the platform
   launcher icon assets with the files in this project. Include
   `assets/aura_red_icon.png`.
3. Fetch packages with `flutter pub get`.
4. Run the checks with `flutter analyze` and `flutter test`.
5. Launch on a connected Android or iOS device with `flutter run`. The iOS
   target supports iPhone and iPad, including landscape layouts and iPad
   multitasking.

The app uses Flutter SDK libraries plus `shared_preferences`, `share_plus`,
`url_launcher`, `qr_flutter`, AppLovin MAX, RevenueCat, and Apple App Tracking Transparency.
Profile and trainer history stays on the device; profile QR codes contain only
the profile values encoded in the code. AppLovin may process device and ad
interaction data for ad delivery and measurement. The iOS onboarding explains
the tracking choice before the system ATT prompt.

## Store setup

The iOS app configures RevenueCat with the public iOS SDK key in
`lib/purchases/pro_service.dart`. Add the non-consumable App Store product
`removeads_2_99` to App Store Connect and RevenueCat, then attach it to the
`dark_aura_aim_panel_pro` entitlement. The app displays the localized store
price, supports purchase restoration, and removes AppLovin ads while that
entitlement is active. Verify purchases with an App Store sandbox account or
TestFlight; a Windows host cannot build or run the iOS target.
