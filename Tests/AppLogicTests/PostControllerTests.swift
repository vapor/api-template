import XCTest
import Foundation
import Testing
import HTTP
@testable import Vapor
@testable import AppLogic

class PostControllerTests: XCTestCase {
    /// This is a requirement for XCTest on Linux
    /// to function properly.
    /// See ./Tests/LinuxMain.swift for examples
    static let allTests = [
        ("testPostRoutes", testPostRoutes),
    ]

    let initialMessage = "I'm a post"
    let updatedMessage = "I have been updated \(Date())"

    /// For these tests, we won't be spinning up a live
    /// server, and instead we'll be passing our constructed
    /// requests programmatically
    /// this is usually an effective way to test your 
    /// application in a convenient and safe manner
    /// See RouteTests for an example of a live server test
    let drop = try! Droplet.testable()

    func testPostRoutes() throws {
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
        let request = try Request(method: .post, uri: "http://0.0.0.0/posts")
        request.json = try JSON(node: ["content": initialMessage])

        let response = drop.respond(to: request)
        let json = response.json
        XCTAssertNotNil(json)
        XCTAssertNotNil(json?["content"])
        XCTAssertNotNil(json?["id"])
        XCTAssertEqual(json?["content"], request.json?["content"])
        return try json?.get("id")
    }

    func fetchOne(id: Int) throws {
        let request = try Request(method: .get, uri: "http://0.0.0.0/posts/\(id)")
        let response = drop.respond(to: request)

        let json = response.json
        XCTAssertNotNil(json)
        XCTAssertNotNil(json?["content"])
        XCTAssertNotNil(json?["id"])
        XCTAssertEqual(json?["id"]?.int, id)
        XCTAssertEqual(json?["content"]?.string, initialMessage)
    }

    func fetchAll(expectCount count: Int) throws {
        let request = try Request(method: .get, uri: "http://0.0.0.0/posts")
        let response = drop.respond(to: request)

        let json = response.json
        XCTAssertNotNil(json?.array)
        XCTAssertEqual(json?.array?.count, count)
    }

    func patch(id: Int) throws {
        let request = try Request(method: .patch, uri: "http://0.0.0.0/posts/\(id)")
        request.json = try JSON(node: ["content": updatedMessage])

        let response = drop.respond(to: request)
        let json = response.json
        XCTAssertNotNil(json)
        XCTAssertNotNil(json?["content"])
        XCTAssertNotNil(json?["id"])
        XCTAssertEqual(json?["id"]?.int, id)
        XCTAssertEqual(json?["content"]?.string, updatedMessage)
    }

    func put(id: Int) throws {
        let request = try Request(method: .put, uri: "http://0.0.0.0/posts/\(id)")
        request.json = try JSON(node: ["content": updatedMessage])

        let response = drop.respond(to: request)
        let json = response.json
        XCTAssertNotNil(json)
        XCTAssertNotNil(json?["content"])
        XCTAssertNotNil(json?["id"])
        XCTAssertEqual(json?["id"]?.int, id)
        XCTAssertEqual(json?["content"]?.string, updatedMessage)
    }

    func deleteOne(id: Int) throws {
        let request = try Request(method: .delete, uri: "http://0.0.0.0/posts/\(id)")
        let response = drop.respond(to: request)
        let json = response.json
        XCTAssertNotNil(json)
        XCTAssertNotNil(json?.object)
        XCTAssertEqual(json?.object?.isEmpty, true)
    }

    func deleteAll() throws {
        let request = try Request(method: .delete, uri: "http://0.0.0.0/posts")
        let response = drop.respond(to: request)
        let json = response.json
        XCTAssertNotNil(json)
        XCTAssertNotNil(json?.array)
        XCTAssertEqual(json?.array?.isEmpty, true)
    }
}
