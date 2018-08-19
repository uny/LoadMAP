import Foundation
import RealmSwift
import RxSwift

protocol TargetRepositoryProtocol {
    func refresh(target: TargetEntity) -> Completable
    func delete(reference: ThreadSafeReference<TargetEntity>)
    func loadAll() -> RealmSwift.Results<TargetEntity>
}

final class TargetRepository: TargetRepositoryProtocol {
    private let dateGenerator: DateGeneratorProtocol
    private let uuidGenerator: UUIDGeneratorProtocol
    private let webService: WebServiceProtocol
    
    init(
        dateGenerator: DateGeneratorProtocol = DateGenerator(),
        uuidGenerator: UUIDGeneratorProtocol = UUIDGenerator(),
        webService: WebServiceProtocol = WebService()) {
        self.dateGenerator = dateGenerator
        self.uuidGenerator = uuidGenerator
        self.webService = webService
    }
    
    func refresh(target: TargetEntity) -> Completable {
        let id: String = {
            if target.id.isEmpty {
                return self.uuidGenerator.generate()
            } else {
                return target.id
            }
        }()
        let urlString = target.urlString
        guard let url = URL(string: urlString) else { return .error(ApplicationError.invalidTargetURL) }
        return self.webService.download(url: url)
            .flatMapCompletable { url in
                let realm = try! Realm()
                try! realm.write {
                    let predicate = NSPredicate(format: "targetId == %@", id)
                    realm.delete(realm.objects(PlaceEntity.self).filter(predicate))
                }
                let json = try JSON(url: url)
                guard let name = json["name"].string else { throw ApplicationError.invalidJSON }
                let places = try json["places"].array.map { place -> PlaceEntity in
                    guard let name = place["name"].string,
                        let latitude = place["latitude"].double,
                        let longitude = place["longitude"].double,
                        let color = place["color"].int else { throw ApplicationError.invalidJSON }
                    var dictionary = place.dictionary
                    dictionary.removeValue(forKey: "name")
                    dictionary.removeValue(forKey: "latitude")
                    dictionary.removeValue(forKey: "longitude")
                    dictionary.removeValue(forKey: "color")
                    let fields: Data
                    do {
                        fields = try PropertyListSerialization.data(fromPropertyList: dictionary, format: .binary, options: 0)
                    } catch {
                        throw ApplicationError.invalidJSON
                    }
                    let entity = PlaceEntity()
                    entity.targetId = id
                    entity.name = name
                    entity.latitude = latitude
                    entity.longitude = longitude
                    entity.color = color
                    entity.fields = fields
                    return entity
                }
                try! realm.write {
                    let entity = TargetEntity()
                    entity.id = id
                    entity.timestamp = self.dateGenerator.now().timeIntervalSince1970
                    entity.name = name
                    entity.urlString = urlString
                    realm.add(entity, update: true)
                }
                try! realm.write {
                    realm.add(places)
                }
                return Completable.empty()
        }.debug()
    }
    
    func delete(reference: ThreadSafeReference<TargetEntity>) {
        let realm = try! Realm()
        guard let entity = realm.resolve(reference) else { return }
        try! realm.write {
            realm.delete(entity)
        }
    }
    
    func loadAll() -> RealmSwift.Results<TargetEntity> {
        let realm = try! Realm()
        return realm.objects(TargetEntity.self).sorted(byKeyPath: #keyPath(TargetEntity.timestamp))
    }
}
