import Foundation
import RealmSwift
import RxSwift

protocol PlaceRepositoryProtocol {
    func load(for targetId: String?) -> RealmSwift.Results<PlaceEntity>
}

final class PlaceRepository: PlaceRepositoryProtocol {
    init() {
    }
    
    func load(for targetId: String?) -> RealmSwift.Results<PlaceEntity> {
        let targetId = targetId ?? ""
        let realm = try! Realm()
        let predicate = NSPredicate(format: "targetId == %@", targetId)
        return realm.objects(PlaceEntity.self).filter(predicate)
    }
}
