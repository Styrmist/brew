import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let defaults = UserDefaults.standard
        if let savedIds = defaults.object(forKey: "SavedIds") as? Data {
            let decoder = JSONDecoder()
            if let loadedIds = try? decoder.decode([String].self, from: savedIds) {
                Constants.savedBeer = loadedIds
            }
        }
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(Constants.savedBeer) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "SavedIds")
        }
    }
}
