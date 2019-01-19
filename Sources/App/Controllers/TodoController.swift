import Vapor

/// Controls basic CRUD operations on `Todo`s.
final class TodoController {
    // Returns a list of all `Todo`s.
    func index(req: Request) throws -> Future<[Todo]> {
        return Todo.query(on: req).all()
    }

    // Saves a decoded `Todo` to the database.
    func create(req: Request) throws -> Future<Todo> {
        return try req.content.decode(Todo.self).flatMap { todo in
            return todo.save(on: req)
        }
    }

    // Deletes a parameterized `Todo`.
    func delete(req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Todo.self).flatMap { todo in
            return todo.delete(on: req)
        }.transform(to: .ok)
    }

    // Updates a parameterized `Todo` via a decoded `TodoUpdateForm`.
    func update(req: Request) throws -> Future<Todo> {
        struct TodoUpdateForm: Content {
            let title: String?
        }

        return try req.parameters.next(Todo.self).flatMap { todo in
            return try req.content.decode(TodoUpdateForm.self).flatMap { todoUpdateForm in
                todo.title = todoUpdateForm.title ?? todo.title
                return todo.save(on: req)
            }
        }
    }
}
