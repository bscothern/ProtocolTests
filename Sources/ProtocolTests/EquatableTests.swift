import XCTest

public protocol EquatableTests: XCTestCase {
    associatedtype EquatableValue: Equatable
    
    /// A range that describes the values that can be passed equatableValue(requestID:) to receive a unique value.
    ///
    /// By default this entire range will be tested.
    /// If this is too large or not desired then use `maximumTestCount` to change this behavior.
    var testableValueRequestIDRange: Range<Int> { get }
    
    /// The maximum number of random elements to request and do comparisons against when running tests.
    ///
    /// defaults to `nil` which will test all of the cases available according to `testableValueRequestIDRange`.
    var maximumTestCount: Int? { get }
    
    /// A function that returns a unique `EquatableValue` instance based on the given `requestID`.
    ///
    /// - Parameter requestID: An ID number to uniquely create an `EquatableValue` to test.
    func equatableValue(requestID: Int) -> EquatableValue
}

extension EquatableTests {
    func runEquatableTests() throws {
        let maximumTestCount = self.maximumTestCount ?? testableValueRequestIDRange.count
    }
}

extension EquatableTests {
    var maximumTestCount: Int? { nil }
}
