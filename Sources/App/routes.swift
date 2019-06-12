import Fluent
import Vapor

func routes(_ r: Routes, _ c: Container) throws {
    r.get { req in
        return "It works!"
    }

    r.get("hello") { req -> String in
        return "Hello, world!"
    }

    let todoController = try TodoController(db: c.make())
    r.get("todos", use: todoController.index)
    r.post("todos", use: todoController.create)
    r.on(.DELETE, "todos", ":todoID", use: todoController.delete)
}
