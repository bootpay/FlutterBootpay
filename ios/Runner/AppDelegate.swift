import UIKit
import Flutter
import SwiftyBootpay

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    BootpayAnalytics.sharedInstance.appLaunch(application_id: "5b8f6a4d396fa665fdc2b5e9") //
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    override func applicationWillResignActive(_ application: UIApplication) {
        BootpayAnalytics.sharedInstance.sessionActive(active: false)
    }
    
    override func applicationDidBecomeActive(_ application: UIApplication) {
        BootpayAnalytics.sharedInstance.sessionActive(active: true)
    }
}
