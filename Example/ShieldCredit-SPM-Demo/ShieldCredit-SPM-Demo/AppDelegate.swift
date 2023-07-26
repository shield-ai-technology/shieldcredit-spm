import UIKit
import ShieldCredit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let config = Configuration(withSiteId: "SHIELD_SITE_ID", secretKey: "SHIELD_SECRET_KEY")
            config.logLevel = LogLevel.info
        config.deviceShieldCallback = CallbackExtension()
        config.environment = .prod
        Shield.setUp(with: config)
        
        return true
    }
}

class CallbackExtension: DeviceShieldCallback {
    func didError(error: NSError) {
        print(error)
    }

    func didSuccess(result: [String: Any]) {
        print(result)
    }
}
