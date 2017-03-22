#if os(Linux)

import XCTest
@testable import AppLogicTests

XCTMain([
    // AppLogicTests
    testCase(PostControllerTests.allTests),
    testCase(RouteTests.allTests),
])

#endif
