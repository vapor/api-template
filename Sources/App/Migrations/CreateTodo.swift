import Fluent

struct CreateTodo: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("todos")
            .id()
            .field("title", .string, .required)
            .field("user_id", .uuid, .required, .references("users", "id"))
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("todos").delete()
    }
}

struct CreateUser: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("users")
            .id()
            .field("name", .string, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("users").delete()
    }
}

struct Seed: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        let tanner = User(name: "Tanner")
        let ziz = User(name: "Ziz")
        let create = tanner.create(on: database)
            .and(ziz.create(on: database))
            .transform(to: ())
        return create.flatMap { _ in
            let a = tanner.$todos.create([
                .init(title: "Finish Vapor 4")
            ], on: database)
            let b = ziz.$todos.create([
                .init(title: "Sleep")
            ], on: database)
            return a.and(b).transform(to: ())
        }
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        Todo.query(on: database).delete()
            .and(User.query(on: database).delete())
            .transform(to: ())
    }
}
