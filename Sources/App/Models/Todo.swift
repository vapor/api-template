import Fluent
import Vapor

/// A single entry of a Todo list.
final class Todo: Model, Content {
    var entity: String {
        return "todos"
    }
    
    /// The unique identifier for this `Todo`.
    var id: Field<Int> {
        return self.id("id")
    }
    
    /// A title describing what this `Todo` entails.
    var title: Field<String> {
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
}
