import FluentSQLite
import Vapor
import Validation

/// A single entry of a Todo list.
final class Todo: SQLiteModel {
    /// The unique identifier for this `Todo`.
    var id: Int?

    /// A title describing what this `Todo` entails.
    var title: String

    /// Creates a new `Todo`.
    init(id: Int? = nil, title: String) {
        self.id = id
        self.title = title
    }
}

/// Allows `Todo` to be used as a dynamic migration.
extension Todo: Migration { }

/// Allows `Todo` to be encoded to and decoded from HTTP messages.
extension Todo: Content { }

/// Allows `Todo` to be used as a dynamic parameter in route definitions.
extension Todo: Parameter { }

struct User: SQLiteUUIDModel {
    var id: UUID?
    var name: String
    var age: Int
    var email: String?
}

extension User: Content { }

extension User: Validatable {
    static func validations() throws -> Validations<User> {
        var validations = Validations(User.self)
        try validations.add(\.name, .alphanumeric && .count(3...))
        try validations.add(\.age, .range(18...))
        try validations.add(\.email, .email || .nil)
        return validations
    }
}
