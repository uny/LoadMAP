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
    
    var stringDictionary: [String: String] {
        return self.object as? [String: String] ?? [:]
    }
}
