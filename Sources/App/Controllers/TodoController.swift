import FluentSQLite
import Vapor

/// Controls basic CRUD operations on `Todo`s.
final class TodoController {
    let db: SQLiteDatabase.ConnectionPool
    init(_ db: SQLiteDatabase.ConnectionPool) {
        self.db = db
    }
    
    /// Returns a list of all `Todo`s.
    func index(_ req: Request) throws -> Future<[Todo]> {
        return db.withConnection { conn in
            return Todo.query(on: conn).all()
        }
    }

    /// Saves a decoded `Todo` to the database.
    func create(_ req: Request) throws -> Future<Todo> {
        return try req.content.decode(Todo.self).flatMap { todo in
            return self.db.withConnection { conn in
                return todo.save(on: req)
            }
        }
    }

    /// Deletes a parameterized `Todo`.
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Todo.self).flatMap { todo in
            return self.db.withConnection { conn in
                return todo.delete(on: req)
            }
        }.transform(to: .ok)
    }
}
