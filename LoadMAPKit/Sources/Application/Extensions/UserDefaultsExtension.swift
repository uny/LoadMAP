import Foundation

enum UserDefaultsKey: String {
    case currentTargetId = "currentTargetId"
}

extension UserDefaults {
    func string(forKey key: UserDefaultsKey) -> String? {
        return self.string(forKey: key.rawValue)
    }
    
    func set(_ string: String, forKey key: UserDefaultsKey) {
        self.set(string, forKey: key.rawValue)
    }
}
