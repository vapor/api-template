import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }
    
    app.get("hello") { req in
        return "Hello, world!"
    }

    app.get("test") { req in
        User.query(on: req.db).with(\.$todos).all()
    }

    let todos = app.grouped("todos").grouped([
        User.nameAuthenticator
    ])
    todos.get { req in
        try req.authc.require(User.self)
            .$todos
            .query(on: req.db)
            .all()
    }
    todos.post { req -> EventLoopFuture<HTTPStatus> in
        let todo = try req.content.decode(Todo.self)
        return try req.authc.require(User.self).$todos
            .create(todo, on: req.db)
            .transform(to: .ok)
    }

    let todo = todos.grouped(.todoID).grouped([
        User.authorizer(parameter: .todoID, isChild: \.$todos)
    ])
    todo.on(.GET) { req in
        try req.authz.require(Todo.self)
    }
    todo.on(.DELETE) { req -> EventLoopFuture<HTTPStatus> in
        try req.authz.require(Todo.self)
            .delete(on: req.db)
            .map { .ok }
    }
}

extension User {
    static var nameAuthenticator: NameAuthenticator {
        .init()
    }
}

struct NameAuthenticator: BearerAuthenticator {
    typealias User = App.User
    func authenticate(bearer: BearerAuthorization, for request: Request) -> EventLoopFuture<User?> {
        User.query(on: request.db).filter(\.$name == bearer.token).first()
    }
}

extension PathComponent {
    static var todoID: Self {
        ":todoID"
    }
}
