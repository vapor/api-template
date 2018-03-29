import Vapor

/// Controlers basic CRUD operations on `Todo`s.
final class TodoController {
    /// Returns a list of all `Todo`s.
    func index(_ req: Request) throws -> Future<[Todo]> {
        return Todo.query(on: req).all()
    }

    /// Saves a decoded `Todo` to the database.
    func create(_ req: Request) throws -> Future<Todo> {
        return try req.content.decode(Todo.self).flatMap(to: Todo.self) { todo in
            return todo.save(on: req)
        }
    }

    /// Deletes a parameterized `Todo`.
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameter(Todo.self).flatMap(to: Void.self) { todo in
            return todo.delete(on: req)
        }.transform(to: .ok)
    }

    /// Updates a decoded `Todo` to the database.
    func update(_ req: Request) throws -> Future<Todo> {
        return try req.content.decode(Todo.self).flatMap(to: Todo.self) { todo in
                return todo.update(on: req)
        }
    }

    /// Finds a parameterized `Todo`.
    func find(_ req: Request) throws -> Future<Todo> {
        return try req.parameter(Todo.self)
    }
}
