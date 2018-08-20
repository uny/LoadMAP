import Foundation

struct PropertyList {
    let object: Any?
    
    init(data: Data) {
        do {
            let object = try PropertyListSerialization.propertyList(from: data, options: [], format: nil)
            self.object = object
        } catch {
            self.object = nil
        }
    }
    
    private init(object: Any?) {
        self.object = object
    }
    
    subscript(key: String) -> PropertyList {
        guard let object = object as? [String: Any] else { return PropertyList(object: nil) }
        return PropertyList(object: object[key])
    }
    
    var url: URL? {
        if let string = self.string {
            return URL(string: string)
        } else {
            return nil
        }
    }
    
    var string: String? {
        return self.object as? String
    }
    
    var dictionary: [String: Any] {
        // TODO: url, string, int, double, ...
        return self.object as? [String: Any] ?? [:]
    }
}
