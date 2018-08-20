import Foundation

enum UserDefaultsKey {
    case currentTargetId
    
    var stringKey: String {
        switch self {
        case .currentTargetId: return "currentTargetId"
        }
    }
}

extension UserDefaults {
    func string(forKey key: UserDefaultsKey) -> String? {
        return self.string(forKey: key.stringKey)
    }
    
    func set(_ string: String, forKey key: UserDefaultsKey) {
        self.set(string, forKey: key.stringKey)
    }
}
