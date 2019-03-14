import Fluent
import Vapor

/// Controls basic CRUD operations on `Todo`s.
final class TodoController {
    /// Fluent database to execute queries on.
    let db: Database
    
    /// Creates a new `TodoController`.
    init(db: Database) {
        self.db = db
    }
    
    /// Returns a list of all `Todo`s.
    func index(req: HTTPRequest, ctx: Context) throws -> EventLoopFuture<[Todo]> {
        return self.db.query(Todo.self).all()
    }

    /// Saves a decoded `Todo` to the database.
    func create(todo: Todo, ctx: Context) throws -> EventLoopFuture<Todo> {
        return todo.save(on: self.db).map { todo }
    }

    /// Deletes a parameterized `Todo`.
    func delete(_ req: HTTPRequest, ctx: Context) throws -> EventLoopFuture<HTTPStatus> {
        fatalError()
    }
}
