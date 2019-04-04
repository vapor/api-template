import Fluent
import Vapor

/// Register your application's routes here.
public func routes(_ r: Routes, _ c: Container) throws {
    // Basic "It works" example
    r.get { req, _ in
        return "It works!"
    }
    
    
    // Basic "Hello, world!" example
    r.get("hello") { req, _ -> String in
        return "Hello, world!"
    }
    
    let psql = try c.make(Databases.self).database(.psql)!
    let todoController = TodoController(db: psql)
    r.get("todos", use: todoController.index)
    r.post("todos", use: todoController.create)
    r.on(.DELETE, to: "todos", ":todoID", use: todoController.delete)
}
