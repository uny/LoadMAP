import XCTest
@testable import LoadMAPKit

final class AppliableTest: XCTestCase {
    func testApply() {
        let expected = 100
        let object = TestObject().apply { object in
            object.value = expected
        }
        XCTAssertEqual(object.value, expected)
    }
    
    final class TestObject: NSObject {
        var value = 0
    }
}
