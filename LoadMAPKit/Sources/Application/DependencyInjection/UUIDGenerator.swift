import Foundation

protocol UUIDGeneratorProtocol {
    func generate() -> String
}

struct UUIDGenerator: UUIDGeneratorProtocol {
    func generate() -> String {
        return UUID().uuidString
    }
}
