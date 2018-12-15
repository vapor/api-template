import Fluent
import Vapor

/// A single entry of a Todo list.
final class Todo: Model {
    struct JSON: Content {
        var id: Int?
        var title: String
    }
    
    var entity: String {
        return "todos"
    }
    
    #warning("TODO: update to shorter syntax when Swift 5 bug fixed")
    
//    /// The unique identifier for this `Todo`.
//    var id: Field<Int> {
//        return self.field("id", nil, .primaryKey)
//    }
//
//    /// A title describing what this `Todo` entails.
//    var title: Field<String> {
//        return self.field("title")
//    }
    
    /// The unique identifier for this `Todo`.
    var id: ModelField<Todo, Int> {
        return self.field("id", nil, .primaryKey)
    }
    
    /// A title describing what this `Todo` entails.
    var title: ModelField<Todo, String> {
        return self.field("title")
    }
    
    /// See `Model`.
    var properties: [Property] {
        return [self.id, self.title]
    }
    
    /// See `Model`.
    var storage: Storage
    
    /// See `Model`.
    init(storage: Storage) {
        self.storage = storage
    }
    
    func json() throws -> JSON {
        return try .init(
            id: self.id.get(),
            title: self.title.get()
        )
    }
}
