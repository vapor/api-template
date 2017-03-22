import Foundation
@testable import AppLogic
@testable import Vapor

extension Droplet {
    static func testable() throws -> Droplet {
        let drop = try Droplet(arguments: ["vapor", "prepare"])
        try AppLogic.setup(drop)
        try drop.runCommands()
        return drop
    }

    // Must be served to activate
    static func live() throws -> Droplet {
        let drop = try Droplet(arguments: ["vapor", "serve"])
        try AppLogic.setup(drop)
        return drop
    }

    func serveInBackground(_ server: ServerConfig?) throws {
        background {
            try! self.run(server: server)
        }
        console.wait(seconds: 0.5)
    }
}
