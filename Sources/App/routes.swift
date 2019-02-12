import Fluent
import Vapor

/// Register your application's routes here.
public func routes(_ r: Routes, _ c: Container) throws {
    // Basic "It works" example
    r.get { req, _ in
        return "It works!"
    }
    
    // Basic "Hello, world!" example
    r.get("hello") { req, _ -> StaticString in
        return "Hello, world!"
    }

    // Example of configuring a controller
    let psql = try c.make(FluentDatabases.self).database(.psql)!
    
    r.get("migrate") { _, _ -> EventLoopFuture<HTTPStatus> in
        return Todo.autoMigration().prepare(on: psql).map { _ in
            return .ok
        }
    }
    
    let todoController = TodoController(db: psql)
    r.get("todos", use: todoController.index)
    r.post("todos", use: todoController.create)
    // r.delete("todos", Todo.parameter, use: todoController.delete)
}
