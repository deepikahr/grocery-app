// import UIKit
// import Flutter
// import GoogleMaps


// @UIApplicationMain
// @objc class AppDelegate: FlutterAppDelegate {
//   override func application(
//     _ application: UIApplication,
//     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//   ) -> Bool {
//     NSString* googleMapApiKey = [[NSProcessInfo processInfo] environment[@"GOOGLE_MAP_API_KEY"];
//     GMSServices.provideAPIKey(googleMapApiKey)
//     GeneratedPluginRegistrant.register(with: self)
//     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//   }
// }

import UIKit
import Flutter
import GoogleMaps


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyBAwPGO0nO-z1aXVgEJg5G_XRAo6RnepSw")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
