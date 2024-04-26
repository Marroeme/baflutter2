import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    GMSServices.provideAPIKey("AIzaSyDpxU8F_yCa2Bk1Sif8p7XbMFHNF3N5hj0")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
