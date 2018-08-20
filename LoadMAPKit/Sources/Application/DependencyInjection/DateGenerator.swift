import Foundation

protocol DateGeneratorProtocol {
    func now() -> Date
}

struct DateGenerator: DateGeneratorProtocol {
    func now() -> Date {
        return Date()
    }
}
