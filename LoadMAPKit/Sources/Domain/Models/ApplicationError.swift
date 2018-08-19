import Foundation

enum ApplicationError: Swift.Error {
    case emptyTargetURL
    case invalidJSON
    case invalidTargetURL
    case unknown
}

extension ApplicationError: LocalizedError {
}
