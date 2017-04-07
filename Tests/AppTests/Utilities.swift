import Foundation
@testable import App
@testable import Vapor
import XCTest
import Testing

extension Droplet {
    static func testable() throws -> Droplet {
        let drop = try Droplet(arguments: ["vapor", "prepare"])
        try App.setup(drop)
        try drop.runCommands()
        return drop
    }

    // Must be served to activate
    static func live() throws -> Droplet {
        let drop = try Droplet(arguments: ["vapor", "serve"])
        try App.setup(drop)
        return drop
    }

    func serveInBackground(_ server: ServerConfig?) throws {
        background {
            try! self.run(server: server)
        }
        console.wait(seconds: 0.5)
    }
}

class TestCase: XCTestCase {
    override func setUp() {
        Testing.onFail = XCTFail
    }
}
