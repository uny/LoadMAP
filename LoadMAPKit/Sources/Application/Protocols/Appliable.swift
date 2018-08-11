import Foundation

protocol Appliable {}

extension Appliable {
    func apply(block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
}

extension NSObject: Appliable {}
