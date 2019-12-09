@testable import App
import Fluent
import XCTVapor

final class AppTests: XCTestCase {
    func testCreateTodo() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        app.databases.use(.sqlite(configuration: .init(storage: .memory)), as: .test, isDefault: true)

        try app.migrator.setupIfNeeded().wait()
        try app.migrator.prepareBatch().wait()

        try app.test(.GET, "todos") { res in
            XCTAssertContent([Todo].self, res) {
                XCTAssertEqual($0.count, 0)
            }
        }.test(.POST, "todos", json: Todo(title: "Test My App")) { res in
            XCTAssertContent(Todo.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.title, "Test My App")
            }
        }.test(.GET, "todos") { res in
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
