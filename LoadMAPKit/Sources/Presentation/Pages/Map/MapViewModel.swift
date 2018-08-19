import Foundation
import RealmSwift

final class MapViewModel {
    private(set) var places: RealmSwift.Results<PlaceEntity>?
    private let placeRepository: PlaceRepositoryProtocol
    private let userDefaults: UserDefaults
    
    init(
        placeRepository: PlaceRepositoryProtocol = PlaceRepository(),
        userDefaults: UserDefaults = .standard) {
        self.placeRepository = placeRepository
        self.userDefaults = userDefaults
        self.places = nil
    }
    
    func reloadPlaces() {
        self.places = self.placeRepository.load(for: self.userDefaults.string(forKey: .currentTargetId))
    }
}
