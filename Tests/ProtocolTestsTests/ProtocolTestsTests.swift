@testable import ProtocolTests
import XCTest

final class ProtocolTestsTests: XCTestCase, CollectionTests {
    typealias CollectionType = [Int]
    typealias Element = Int
    
    func testCollectionProtocol() throws {
        try runCollectionTests()
    }

    func testSuiteEmptyCollection() -> [Int]? {
        []
    }
    
    func testSuitePopulatedCollection() -> [Int]? {
        [1, 2, 3, 4, 5]
    }
}
