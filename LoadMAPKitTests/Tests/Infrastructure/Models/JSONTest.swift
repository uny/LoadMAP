import XCTest
@testable import LoadMAPKit

final class JSONTest: XCTestCase {
    func testInitWithInvalidJSON() {
        let url = Bundle(for: type(of: self)).url(forResource: "InvalidJSON", withExtension: "txt")!
        XCTAssertThrowsError(try JSON(url: url)) { error in
            let expected = ApplicationError.invalidJSON
            XCTAssertEqual(error._domain, expected._domain)
            XCTAssertEqual(error._code, expected._code)
        }
    }
    
    func testNotFoundKey() {
        let url = Bundle(for: type(of: self)).url(forResource: "Simple", withExtension: "json")!
        let json = try! JSON(url: url)
        XCTAssertEqual(json["none"].string, nil)
    }
    
    func testString() {
        let url = Bundle(for: type(of: self)).url(forResource: "Simple", withExtension: "json")!
        let json = try! JSON(url: url)
        XCTAssertEqual(json["string"].string, "string")
    }
    
    func testInt() {
        let url = Bundle(for: type(of: self)).url(forResource: "Simple", withExtension: "json")!
        let json = try! JSON(url: url)
        XCTAssertEqual(json["integer"].int, 123)
    }
    
    func testDouble() {
        let url = Bundle(for: type(of: self)).url(forResource: "Simple", withExtension: "json")!
        let json = try! JSON(url: url)
        XCTAssertEqual(json["double"].double, 1.23)
    }
    
    func testArray() {
        let url = Bundle(for: type(of: self)).url(forResource: "Simple", withExtension: "json")!
        let json = try! JSON(url: url)
        let actual = json["array"].array.compactMap { $0.int }
        XCTAssertEqual(actual, [1, 2, 3])
    }
    
    func testArray_NotFoundKey() {
        let url = Bundle(for: type(of: self)).url(forResource: "Simple", withExtension: "json")!
        let json = try! JSON(url: url)
        let actual = json["none"].array
        XCTAssertTrue(actual.isEmpty)
    }
    
    func testDictionary() {
        let url = Bundle(for: type(of: self)).url(forResource: "Simple", withExtension: "json")!
        let json = try! JSON(url: url)
        let actual = json.dictionary["string"] as? String
        XCTAssertEqual(actual, "string")
    }
}
