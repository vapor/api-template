import Fluent
import Vapor

/// A single entry of a Todo list.
final class Todo: Model, Content {
    struct Properties: ModelProperties {
        /// The unique identifier for this `Todo`.
        let id = Field<Int>("id")
        /// A title describing what this `Todo` entails.
        let title = Field<String>("title")
    }
    static let entity = "todos"
    
    /// `Model` conformance.
    static var properties = Properties()
    
    /// `Model` conformance.
    var storage: Storage
    
    /// `Model` conformance.
    init(storage: Storage) {
        self.storage = storage
    }
}
