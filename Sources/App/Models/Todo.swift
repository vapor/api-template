import Fluent
import Vapor

/// A single entry of a Todo list.
struct Todo: Model {
    static let shared = Todo()
    static let entity = "todos"
    
    /// The unique identifier for this `Todo`.
    let id = Field<Int?>("id")
    /// A title describing what this `Todo` entails.
    let title = Field<String>("title")
    
}
