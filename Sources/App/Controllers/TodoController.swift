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
    func index(req: Request) throws -> EventLoopFuture<[Row<Todo>]> {
        return Todo.query(on: self.db).all()
    }

    /// Saves a decoded `Todo` to the database.
    func create(req: Request) throws -> EventLoopFuture<Row<Todo>> {
        let todo = try req.content.decode(Row<Todo>.self)
        return todo.save(on: self.db).map { todo }
    }

    /// Deletes a parameterized `Todo`.
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Todo.find(req.parameters.get("todoID"), on: self.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: self.db) }
            .transform(to: .ok)
    }
}
