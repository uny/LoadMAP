import RealmSwift

final class PlaceEntity: RealmSwift.Object {
    @objc dynamic var targetId = ""
    @objc dynamic var name = ""
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0
    @objc dynamic var color = 0
    @objc dynamic var fields = Data()
}
