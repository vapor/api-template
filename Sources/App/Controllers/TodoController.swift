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
        return self.db.find(Todo.self, ctx.parameters.get(Todo.self)).flatMap { todo in
            return todo.delete(on: self.db)
        }.transform(to: .ok)
    }
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

extension Parameters {
    public func get<Model>(_ model: Model.Type) -> Model.ID?
        where Model: FluentKit.Model, Model.ID: LosslessStringConvertible
    {
        return self.get(Model.entity, as: Model.ID.self)
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

extension Database {
    public func find<Model>(
        _ model: Model.Type,
        _ id: Model.ID?,
        or error: Error = Abort(.notFound)
    ) -> EventLoopFuture<Model>
        where Model: FluentKit.Model, Model.ID: LosslessStringConvertible
    {
        guard let id = id else {
            return self.eventLoop.makeFailedFuture(error)
        }
        return self.query(Model.self).filter(\.id == id).first().unwrap(or: error)
    }
}

extension Model {
    public static func find(_ id: Self.ID?, on database: Database) -> EventLoopFuture<Self?> {
        guard let id = id else {
            return database.eventLoop.makeSucceededFuture(nil)
        }
        return database.query(Self.self).filter(\.id == id).first()
    }
}
