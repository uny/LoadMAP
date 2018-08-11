import Foundation

enum ApplicationError: Swift.Error {
    case emptyTargetURL
    case invalidTargetURL
}

extension ApplicationError: LocalizedError {
}
