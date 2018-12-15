import Fluent
import Vapor

/// Controls basic CRUD operations on `Todo`s.
final class TodoController {
    /// Fluent database to execute queries on.
    let db: FluentDatabase
    
    /// Creates a new `TodoController`.
    init(db: FluentDatabase) {
        self.db = db
    }
    
    /// Returns a list of all `Todo`s.
    func index(_ req: HTTPRequest) throws -> EventLoopFuture<[Todo.JSON]> {
        return self.db.query(Todo.self).all().thenThrowing { todos in
            return try todos.map { try $0.json() }
        }
    }

    /// Saves a decoded `Todo` to the database.
    func create(_ req: HTTPRequest) throws -> EventLoopFuture<Todo.JSON> {
        let data = try req.content.decode(Todo.JSON.self)
        let todo = Todo.new()
        todo.title.set(to: data.title)
        return todo.save(on: self.db).thenThrowing { _ in
            return try todo.json()
        }
    }

    /// Deletes a parameterized `Todo`.
    func delete(_ req: HTTPRequest) throws -> EventLoopFuture<HTTPStatus> {
        fatalError()
    }
}
