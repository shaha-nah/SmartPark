import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    [GeneratedPluginRegistrant registerWithRegistry:self];
    [GMSServices provideAPIKey:@"AIzaSyDFYJxOUvHV9fNBom7oPiUJm_WhLQCMQmM"];
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
