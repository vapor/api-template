import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Redirect root to "/hello"
    router.get("/") { req in
        return req.redirect(to: "hello")
    }

    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }

    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.delete("todos", Todo.parameter, use: todoController.delete)
}
