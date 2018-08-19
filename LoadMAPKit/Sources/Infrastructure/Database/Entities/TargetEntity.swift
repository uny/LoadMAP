import RealmSwift

final class TargetEntity: RealmSwift.Object {
    @objc dynamic var id = ""
    @objc dynamic var timestamp = TimeInterval(0)
    @objc dynamic var name = ""
    @objc dynamic var urlString = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
