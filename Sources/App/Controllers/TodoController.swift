import Fluent
import Vapor

final class TodoController {
    let db: Database

    init(db: Database) {
        self.db = db
    }

    func index(req: Request) throws -> EventLoopFuture<[Todo]> {
        return Todo.query(on: self.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<Todo> {
        let todo = try req.content.decode(Todo.self)
        return todo.save(on: self.db).map { todo }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Todo.find(req.parameters.get("todoID"), on: self.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: self.db) }
            .transform(to: .ok)
    }
}
