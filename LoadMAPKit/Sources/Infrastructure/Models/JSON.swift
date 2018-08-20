import Foundation

struct JSON {
    let object: Any?
    
    init(url: URL) throws {
        guard let stream = InputStream(url: url) else { throw ApplicationError.invalidJSON }
        stream.open()
        defer { stream.close() }
        do {
            let object = try JSONSerialization.jsonObject(with: stream)
            self.object = object
        } catch {
            throw ApplicationError.invalidJSON
        }
    }
    
    private init(object: Any?) {
        self.object = object
    }
    
    subscript(key: String) -> JSON {
        guard let object = object as? [String: Any] else { return JSON(object: nil) }
        return JSON(object: object[key])
    }
    
    var string: String? {
        return self.object as? String
    }
    
    var int: Int? {
        return self.object as? Int
    }
    
    var double: Double? {
        return self.object as? Double
    }
    
    var array: [JSON] {
        return (self.object as? [Any] ?? []).map { object in JSON(object: object) }
    }
    
    var dictionary: [String: Any] {
        return self.object as? [String: Any] ?? [:]
    }
}
