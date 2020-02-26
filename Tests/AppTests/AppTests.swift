@testable import App
import Fluent
import XCTVapor

final class AppTests: XCTestCase {
    func testCreateTodo() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        // replace default database with in-memory db for testing
        app.databases.use(.sqlite(.memory), as: .test, isDefault: true)
        // run migrations automatically
        try app.autoMigrate().wait()

        try app.test(.GET, "todos") { res in
            XCTAssertContent([Todo].self, res) {
                XCTAssertEqual($0.count, 0)
            }
        }.test(.POST, "todos", beforeRequest: { req in
            try req.content.encode(Todo(title: "Test My App"))
        }, afterResponse: { res in
            XCTAssertContent(Todo.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.title, "Test My App")
            }
        }).test(.GET, "todos") { res in
            XCTAssertContent([Todo].self, res) {
                XCTAssertEqual($0.count, 1)
            }
        }
    }
}

extension DatabaseID {
    static var test: Self {
        .init(string: "test")
    }
}
