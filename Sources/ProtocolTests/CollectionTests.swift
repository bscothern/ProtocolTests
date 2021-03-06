import XCTest

public protocol CollectionTests: XCTestCase {
    associatedtype CollectionType: Collection where CollectionType.Element == Element
    associatedtype Element: Equatable

    /// Create a `Collection` where `isEmpty` returns `true`.
    func protocolTestSuiteEmptyCollection() -> CollectionType?

    /// Create a `Collection` with at least 1 `Element` if you want to test this behavior.
    ///
    /// - Note: This will iterate over your entire collection multiple times and make copy of elements, so if it is very large it may take a while.
    func protocolTestSuitePopulatedCollection() -> CollectionType?
}

public enum CollectionTestsError: Error {
    case invalidIndicies(String)
}

extension CollectionTests {
    public func protocolTestSuiteEmptyCollection() -> CollectionType? {
        nil
    }

    public func protocolTestSuitePopulatedCollection() -> CollectionType? {
        nil
    }
}

extension CollectionTests {
    public func runCollectionTests() throws {
        try emptyCollectionTests()
        try populatedCollectionTests()
    }
}

extension CollectionTests {
    func emptyCollectionTests() throws {
        guard let collection = protocolTestSuiteEmptyCollection() else { return }
        XCTAssert(collection.isEmpty, "Empty Collection Tests require that you provide an empty collection")
        
        // MARK: Ensure indices are working correctly
        XCTAssertEqual(collection.startIndex, collection.endIndex, "Collection requires that startIndex == endIndex when empty")
        
        XCTAssertEqual(collection.distance(from: collection.startIndex, to: collection.endIndex), collection.count, "Collection requires that distance(from:to:) returns the count when you go from a start index to the end indext")
    }
}

extension CollectionTests {
    func populatedCollectionTests() throws {
        guard let collection = protocolTestSuitePopulatedCollection() else { return }
        XCTAssertFalse(collection.isEmpty, "Populated Collection Tests require that you provide a non-empty collection")
        
        // MARK: Ensure indices are working correctly
        XCTAssertNotEqual(collection.startIndex, collection.endIndex, "Collection requires that startIndex != endIndex when not empty")
        let indicies = collection.indices
        XCTAssertEqual(collection.startIndex, indicies.first, "Collection requires that startIndex is equal to the first index returned by indices")
        guard let lastValidIndex = indicies.reversed().first else {
            throw CollectionTestsError.invalidIndicies("Unable to find a last valid index. The indices property is not behaving correctly.")
        }
        XCTAssertGreaterThan(collection.endIndex, lastValidIndex, "Collection requires that endIndex is greater than its last valid index returned by indices")
        
        let endIndex = collection.index(after: lastValidIndex)
        XCTAssertEqual(collection.endIndex, endIndex, "Collection requies that index(after:) on the last index of indices returns the endIndex")
        
        var values = [Element]()
        for i in indicies {
            values.append(collection[i])
        }
        values.reverse()
        for i in indicies {
            let value = collection[i]
            XCTAssertEqual(value, values.removeLast(), "Collection requies that an index remains valid and returns the same element if it is not mutated.")
        }
        
        XCTAssertEqual(collection.distance(from: collection.startIndex, to: collection.endIndex), collection.count, "Collection requires that distance(from:to:) returns the count when you go from a start index to the end indext")
        
        // MARK: Test Slicing
        
        // Full Slice
        let fullSlice = collection[...]
        zip(collection, fullSlice).forEach { element, sliceElement in
            XCTAssertEqual(element, sliceElement, "Collection requies that slices have the same the iteration order as its normal Sequence iteration")
        }
        
        // Open End
        let openEndSlice = collection[collection.index(after: collection.startIndex)...]
        zip(collection.dropFirst(), openEndSlice).forEach { element, sliceElement in
            XCTAssertEqual(element, sliceElement, "Collection requies that slices have the same the iteration order as its normal Sequence iteration")
        }
        
        // Open Start
        let openStartSlice = collection[...collection.index(collection.startIndex, offsetBy: 3)]
        zip(collection, openStartSlice).forEach { element, sliceElement in
            XCTAssertEqual(element, sliceElement, "Collection requies that slices have the same the iteration order as its normal Sequence iteration")
        }
        
        // Closed Slice
        let closedSlice = collection[collection.index(after: collection.startIndex)...collection.index(collection.startIndex, offsetBy: 3)]
        zip(collection.dropFirst(), closedSlice).forEach {element, sliceElement in
            XCTAssertEqual(element, sliceElement, "Collection requies that slices have the same the iteration order as its normal Sequence iteration")
        }

        // Slice
        let slice = collection[collection.index(after: collection.startIndex)..<collection.index(collection.startIndex, offsetBy: 3)]
        zip(collection.dropFirst(), slice).forEach {element, sliceElement in
            XCTAssertEqual(element, sliceElement, "Collection requies that slices have the same the iteration order as its normal Sequence iteration")
        }
    }
}
