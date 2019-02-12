import Fluent
import Vapor

/// A single entry of a Todo list.
final class Todo: FluentModel, Content {
    var entity: String {
        return "todos"
    }
    
    /// The unique identifier for this `Todo`.
    var id: Field<Int> {
        return self.field("id", .int, .identifier)
    }
    
    /// A title describing what this `Todo` entails.
    var title: Field<String> {
        return self.field("title", .string, .required)
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
}
