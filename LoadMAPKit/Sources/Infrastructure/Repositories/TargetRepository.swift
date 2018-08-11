import Foundation
import RealmSwift
import RxSwift

protocol TargetRepositoryProtocol {
    func add(target: TargetEntity)
}

final class TargetRepository: TargetRepositoryProtocol {
    private let realmConfiguration: RealmSwift.Realm.Configuration
    
    init(realmConfiguration: RealmSwift.Realm.Configuration = .defaultConfiguration) {
        self.realmConfiguration = realmConfiguration
    }
    
    func add(target: TargetEntity) {
        let realm = try! Realm(configuration: self.realmConfiguration)
        realm.add(target)
    }
}
