import Foundation
import RxSwift

final class TargetListViewModel {
    private let targetRepository: TargetRepositoryProtocol
    
    init(targetRepository: TargetRepositoryProtocol = TargetRepository()) {
        self.targetRepository = targetRepository
    }
    
    func addNewTarget(urlString: String?) -> Completable {
        guard let urlString = urlString else { return Completable.error(ApplicationError.emptyTargetURL) }
        guard let _ = URL(string: urlString) else { return Completable.error(ApplicationError.invalidTargetURL) }
        let entity = TargetEntity()
        entity.urlString = urlString
        let targetRepository = self.targetRepository
        return Single.just(entity)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .subscribeOn(MainScheduler.instance)
            .flatMapCompletable { entity in
                targetRepository.add(target: entity)
                return Completable.empty()
        }
    }
}
