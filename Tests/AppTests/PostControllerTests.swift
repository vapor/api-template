import XCTest
import Testing
import HTTP
import Sockets
@testable import Vapor
@testable import App

class PostControllerTests: TestCase {
    /// This is a requirement for XCTest on Linux
    /// to function properly.
    /// See ./Tests/LinuxMain.swift for examples
    static let allTests = [
        ("testPostRoutes", testPostRoutes),
    ]

    let initialMessage = "I'm a post"
    let updatedMessage = "I have been updated \(Date())"
    var port: Sockets.Port!

    /// For these tests, we won't be spinning up a live
    /// server, and instead we'll be passing our constructed
    /// requests programmatically
    /// this is usually an effective way to test your 
    /// application in a convenient and safe manner
    /// See RouteTests for an example of a live server test
    let drop = try! Droplet.testable()
    
    func testPostRoutes() throws {
        port = drop.config["server.port"]?.int?.port ?? 8080
        
        let idOne = try create() ?? -1
        try fetchOne(id: idOne)
        try fetchAll(expectCount: 1)
        try patch(id: idOne)
        try put(id: idOne)

        let idTwo = try create() ?? -1
        try fetchAll(expectCount: 2)

        try deleteOne(id: idOne)
        try fetchAll(expectCount: 1)

        try deleteOne(id: idTwo)
        try fetchAll(expectCount: 0)

        let newIds = try (1...5).map { _ in try create() ?? 1 }
        try fetchAll(expectCount: newIds.count)
        try deleteAll()
        try fetchAll(expectCount: 0)
    }

    func create() throws -> Int? {
        let req = Request.makeTest(method: .post, port: port, path: "/posts")
        req.json = try JSON(node: ["content": initialMessage])

        let res = try drop.testResponse(to: req)
        let json = res.json
        XCTAssertNotNil(json)
        XCTAssertNotNil(json?["content"])
        XCTAssertNotNil(json?["id"])
        XCTAssertEqual(json?["content"], req.json?["content"])
        return try json?.get("id")
    }

    func fetchOne(id: Int) throws {
        let req = Request.makeTest(method: .get, port: port, path: "/posts/\(id)")
        let res = try drop.testResponse(to: req)

        let json = res.json
        XCTAssertNotNil(json)
        XCTAssertNotNil(json?["content"])
        XCTAssertNotNil(json?["id"])
        XCTAssertEqual(json?["id"]?.int, id)
        XCTAssertEqual(json?["content"]?.string, initialMessage)
    }

    func fetchAll(expectCount count: Int) throws {
        let req = Request.makeTest(method: .get, port: port, path: "/posts")
        let res = try drop.testResponse(to: req)

        let json = res.json
        XCTAssertNotNil(json?.array)
        XCTAssertEqual(json?.array?.count, count)
    }

    func patch(id: Int) throws {
        let req = Request.makeTest(method: .patch, port: port, path: "/posts/\(id)")
        req.json = try JSON(node: ["content": updatedMessage])

        let res = try drop.testResponse(to: req)
        let json = res.json
        XCTAssertNotNil(json)
        XCTAssertNotNil(json?["content"])
        XCTAssertNotNil(json?["id"])
        XCTAssertEqual(json?["id"]?.int, id)
        XCTAssertEqual(json?["content"]?.string, updatedMessage)
    }

    func put(id: Int) throws {
        let req = Request.makeTest(method: .put, port: port, path: "/posts/\(id)")
        req.json = try JSON(node: ["content": updatedMessage])

        let res = try drop.testResponse(to: req)
        let json = res.json
        XCTAssertNotNil(json)
        XCTAssertNotNil(json?["content"])
        XCTAssertNotNil(json?["id"])
        XCTAssertEqual(json?["id"]?.int, id)
        XCTAssertEqual(json?["content"]?.string, updatedMessage)
    }

    func deleteOne(id: Int) throws {
        let req = Request.makeTest(method: .delete, port: port, path: "/posts/\(id)")
        try drop.testResponse(to: req)
            .assertStatus(is: .ok)
    }

    func deleteAll() throws {
        let req = Request.makeTest(method: .delete, port: port, path: "/posts")
        try drop.testResponse(to: req)
            .assertStatus(is: .ok)
    }
}
