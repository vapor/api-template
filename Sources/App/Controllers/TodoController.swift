import Fluent
import Vapor


struct TodoFilters: URLContent {
    var title: String?
}

/// Controls basic CRUD operations on `Todo`s.
final class TodoController {
    /// Fluent database to execute queries on.
    let db: FluentDatabase
    
    /// Creates a new `TodoController`.
    init(db: FluentDatabase) {
        self.db = db
    }
    
    /// Returns a list of all `Todo`s.
    func index(filters: TodoFilters) throws -> EventLoopFuture<[Todo]> {
        let query = self.db.query(Todo.self)
        if let title = filters.title {
            _ = query.filter(\.title == title)
        }
        return query.all()
    }

    /// Saves a decoded `Todo` to the database.
    func create(todo: Todo, ctx: Context) throws -> EventLoopFuture<Todo> {
        return todo.save(on: self.db).map { todo }
    }

    /// Deletes a parameterized `Todo`.
    func delete(_ req: HTTPRequest) throws -> EventLoopFuture<HTTPStatus> {
        fatalError()
    }
}
