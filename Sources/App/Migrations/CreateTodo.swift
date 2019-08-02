import Fluent

struct CreateTodo: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return Todo.schema(on: database)
            .field(\.$id, .int, .identifier(auto: true))
            .field(\.$title, .string, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return Todo.schema(on: database).delete()
    }
}
