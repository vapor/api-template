import XCTest
import Foundation
import Testing
import HTTP
@testable import Vapor
@testable import App

class RouteTests: XCTestCase {
    /// This is a requirement for XCTest on Linux
    /// to function properly.
    /// See ./Tests/LinuxMain.swift for examples
    static let allTests = [
        ("testWelcome", testWelcome),
    ]

    func testWelcome() throws {
        // This is a live test. We're going to actually serve
        // an instance of our server at port 7777
        // we can interact with this server using live client requests
        let drop = try Droplet.live()
        // tells the server to start on port 7777
        try drop.serveInBackground(ServerConfig(port: 7777))

        // we're using a live lient to interact with our droplet through 
        // raw http
        let liveResponse = try drop.client.get("http://0.0.0.0:7777")

        // Landing page assertions
        XCTAssertEqual(liveResponse.status, .ok)
        let string = liveResponse.body.bytes?.makeString() ?? ""
        XCTAssert(!string.isEmpty)
        XCTAssert(string.contains("Host: 0.0.0.0"))
    }
}
