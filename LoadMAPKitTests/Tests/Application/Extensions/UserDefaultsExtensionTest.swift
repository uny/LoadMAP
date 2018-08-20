import XCTest
@testable import LoadMAPKit

final class UserDefaultsExtensionTest: XCTestCase {
    func testStringWithKey() {
        let key = UserDefaultsKey.currentTargetId
        let userDefaults = UserDefaults()
        let expected = self.name
        userDefaults.set(expected, forKey: key)
        XCTAssertEqual(userDefaults.string(forKey: key), expected)
    }
}
