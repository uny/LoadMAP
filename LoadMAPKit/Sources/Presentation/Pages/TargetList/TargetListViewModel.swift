import Foundation
import RealmSwift
import RxSwift

final class TargetListViewModel {
    let targets: RealmSwift.Results<TargetEntity>
    private let targetRepository: TargetRepositoryProtocol
    private let userDefaults: UserDefaults
    private let webService: WebServiceProtocol
    
    init(
        targetRepository: TargetRepositoryProtocol = TargetRepository(),
        userDefaults: UserDefaults = .standard,
        webService: WebServiceProtocol = WebService()) {
        self.targetRepository = targetRepository
        self.userDefaults = userDefaults
        self.webService = webService
        self.targets = targetRepository.loadAll()
    }
    
    func addNewTarget(urlString: String?) -> Completable {
        guard let urlString = urlString, !urlString.isEmpty else { return Completable.error(ApplicationError.emptyTargetURL) }
        let targetRepository = self.targetRepository
        return Single.just(urlString)
            .flatMapCompletable { urlString in
                let entity = TargetEntity()
                entity.urlString = urlString
                return targetRepository.refresh(target: entity)
            }.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .observeOn(MainScheduler.instance)
    }
    
    func select(target: TargetEntity) -> Single<[Int]> {
        let userDefaults = self.userDefaults
        let id = target.id
        let targets = Array(self.targets.map { $0.id })
        return Single.just(id)
            .map { id in
                var indices = [Int]()
                if let oldValue = userDefaults.string(forKey: UserDefaultsKey.currentTargetId),
                    let oldIndex = (targets.index { $0 == oldValue}) {
                    indices.append(oldIndex)
                }
                if let newIndex = (targets.index { $0 == id }) {
                    indices.append(newIndex)
                }
                userDefaults.set(id, forKey: UserDefaultsKey.currentTargetId)
                return indices
            }.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .observeOn(MainScheduler.instance)
    }
    
    func refresh(target: TargetEntity) -> Completable {
        let id = target.id
        let urlString = target.urlString
        let targetRepository = self.targetRepository
        return Single.just(id)
            .flatMapCompletable { id in
                let entity = TargetEntity()
                entity.id = id
                entity.urlString = urlString
                return targetRepository.refresh(target: entity)
            }.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .observeOn(MainScheduler.instance)
    }
    
    func delete(target: TargetEntity) -> Completable {
        let reference = ThreadSafeReference(to: target)
        let targetRepository = self.targetRepository
        return Single.just(reference)
            .flatMapCompletable { reference in
                targetRepository.delete(reference: reference)
                return Completable.empty()
            }.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .observeOn(MainScheduler.instance)
    }
    
    func cellModel(at item: Int) -> CellModel {
        let target = self.targets[item]
        let name: String = {
            if target.name.isEmpty {
                return target.urlString
            } else {
                return target.name
            }
        }()
        let timestamp: String = {
            if target.timestamp == 0 {
                return "To be refreshed"
            } else {
                return PrivateConstants.timestampDateFormatter.string(from: Date(timeIntervalSince1970: target.timestamp))
            }
        }()
        let isSelected = target.id == self.userDefaults.string(forKey: UserDefaultsKey.currentTargetId)
        return CellModel(name: name, timestamp: timestamp, isSelected: isSelected)
    }
    
    struct CellModel {
        let name: String
        let timestamp: String
        let isSelected: Bool
    }
    
    enum PrivateConstants {
        static let timestampDateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .medium
            return formatter
        }()
    }
}
