import Fluent
import Vapor

final class Todo: Model, Content, Authorizable {
    static let schema = "todos"
    
    @ID(key: "id")
    var id: UUID?

    @Field(key: "title")
    var title: String

    @Parent(key: "user_id")
    var user: User

    init() { }

    init(id: UUID? = nil, title: String) {
        self.id = id
        self.title = title
    }
}


final class User: Model, Content, Authenticatable {
    static let schema = "users"

    @ID(key: "id")
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Children(for: \.$user)
    var todos: [Todo]

    init() { }

    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
}
