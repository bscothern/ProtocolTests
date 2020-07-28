# ProtocolTests
*A Swift package to help verify protocol conformances are correct.*

Protocols are a fundamental building block of scalable Swift code.
Part of the challenge of working with them is making sure that your conformances to the standard library protocols is correct.
This package is all about making that as easy as possible by providing some basic protocols to add to your `XCTestCase` instances that have a few basic requirements so that your implimentation of the protocol can be verified.

## Intallation
*This package is intended for use in `testTarget`s not normal `target`s of your `Pacakge.swift`*

```swift
let package = Package(
    ...
    dependencies: [
        .package(url: "https://github.com/bscothern/ProtocolTests.git", .upToNextMinor(from: "0.2.0"))
    ],
    ...
)
```
The goal is to have source breaking changes on minor changes until a major version is released.

## Using this Package

Each test suite has a protocol requirements that when implimented will have the appropriate suite of tests run. If there are multiple test suites then functions prefixed with `testSuite` are the ones that determine which tests are run. If no functions have the `testSuite` prefix then all tests are run based on values returned by the protocol requirements.

Once you have implimented the functions and any support properties needed for the tests you will need to create a test in your `XCTestCase` type that calls the "Started by" function that is with the associated protocol.

### Supported Protocol

| Protocol | Test Protocol | Started by | Number of Test Suites |
|----------|---------------|------------|-----------------------|
| `Collection` | `CollectionTests` | `runCollectionTests()` | 2 |
| `Equatable` | `EquatableTests` | `runEquatableTests()` | 1 |

## Example Usage
```swift
final class ExampleCollectionTests: XCTestCase, CollectionTests {
    // Associated type requirements of `CollectionTests`
    typealias CollectionType = [Int]
    typealias Element = Int
    
    // This starts the `CollectionTests` test suite.
    func testCollectionProtocol() throws {
        try runCollectionTests()
    }

    // This is a enables the empty collection test suite of `CollectionTests`.
    func createEmptyCollection() -> [Int]? {
        []
    }
    
    // This enables the populated collection test suite of `CollectionTests`.
    func createPopulatedCollection() -> [Int]? {
        [1, 2, 3, 4, 5]
    }
}
```
