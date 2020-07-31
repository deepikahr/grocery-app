import UIKit
import Flutter
import GoogleMaps
import Foundation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // if let value = ProcessInfo.processInfo.environment["GOOGLE_MAP_API_KEY"] {
    // GMSServices.provideAPIKey(value)
    // }
    // NSString* googleMapApiKey = [[NSProcessInfo processInfo] environment[@"GOOGLE_MAP_API_KEY"]
     GMSServices.provideAPIKey(ProcessInfo.processInfo.environment["GOOGLE_MAP_API_KEY"])
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
