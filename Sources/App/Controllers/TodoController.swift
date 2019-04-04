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
    func index(req: HTTPRequest, ctx: Context) throws -> EventLoopFuture<[Todo.Row]> {
        return self.db.query(Todo.self).all()
    }

    /// Saves a decoded `Todo` to the database.
    func create(todo: Todo.Row, ctx: Context) throws -> EventLoopFuture<Todo.Row> {
        return todo.save(on: self.db).map { todo }
    }

    /// Deletes a parameterized `Todo`.
    func delete(_ req: HTTPRequest, ctx: Context) throws -> EventLoopFuture<HTTPStatus> {
        return Todo.find(ctx.parameters.get("todoID"), on: self.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: self.db) }
            .transform(to: .ok)
    }
    
    #warning("TODO: allow decoding content + query in same signature + access headers")
}

protocol _Optional {
    associatedtype _Wrapped
    var _wrapped: _Wrapped? { get }
}
extension Optional: _Optional {
    var _wrapped: Wrapped? {
        return self.wrapped
    }
}

extension ModelRow: Content { }

extension Parameters {
    public func get<T>(_ name: String, as type: T.Type = T.self) -> T?
        where T: LosslessStringConvertible
    {
        return self.get(name).flatMap(T.init)
    }
}

extension EventLoopFuture where Value: _Optional {
    func unwrap(or error: Error) -> EventLoopFuture<Value._Wrapped> {
        return self.flatMapThrowing { value in
            guard let value = value._wrapped else {
                throw error
            }
            return value
        }
    }
}
