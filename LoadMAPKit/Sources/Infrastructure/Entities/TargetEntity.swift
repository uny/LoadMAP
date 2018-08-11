import RealmSwift

final class TargetEntity: RealmSwift.Object {
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var urlString = ""
}
