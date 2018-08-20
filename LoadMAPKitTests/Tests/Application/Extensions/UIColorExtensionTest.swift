import XCTest
@testable import LoadMAPKit

final class UIColorExtensionTest: XCTestCase {
    func testInitWithHex() {
        let hex = 0x123456
        let expected = UIColor(red: 0x12 / 0xFF, green: 0x34 / 0xFF, blue: 0x56 / 0xFF, alpha: 1)
        let actual = UIColor(hex: hex)
        XCTAssertEqual(actual, expected)
    }
}
