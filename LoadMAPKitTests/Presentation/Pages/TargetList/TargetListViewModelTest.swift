import XCTest
@testable import LoadMAPKit
import RxBlocking
import RxSwift
import RxTest

final class TargetListViewModelTest: XCTestCase {
    func testAddNewTarget_NilURLString() {
        let targetRepository = TargetRepository()
        let model = TargetListViewModel(targetRepository: targetRepository)
        XCTAssertThrowsError(try model.addNewTarget(urlString: nil).toBlocking().toArray()) { actual in
            let expected = ApplicationError.emptyTargetURL
            XCTAssertEqual(actual._domain, expected._domain)
            XCTAssertEqual(actual._code, expected._code)
        }
    }
    
    func testAddNewTarget_InvalidURLString() {
        let targetRepository = TargetRepository()
        let model = TargetListViewModel(targetRepository: targetRepository)
        XCTAssertThrowsError(try model.addNewTarget(urlString: "").toBlocking().toArray()) { actual in
            let expected = ApplicationError.invalidTargetURL
            XCTAssertEqual(actual._domain, expected._domain)
            XCTAssertEqual(actual._code, expected._code)
        }
    }
    
    func testAddNewTarget_ValidURLString() {
        let targetRepository = TargetRepository()
        let model = TargetListViewModel(targetRepository: targetRepository)
        let expected = "https://example.com"
        _ = try! model.addNewTarget(urlString: expected).toBlocking().first()
        XCTAssertEqual(targetRepository.targets.first?.urlString, expected)
    }
    
    final class TargetRepository: TargetRepositoryProtocol {
        private(set) var targets = [TargetEntity]()
        
        func add(target: TargetEntity) {
            self.targets.append(target)
        }
    }
}
