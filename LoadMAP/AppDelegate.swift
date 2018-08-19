import UIKit
import RealmSwift

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        RealmSwift.Realm.Configuration.defaultConfiguration.deleteRealmIfMigrationNeeded = true
        return true
    }
}
