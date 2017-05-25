import Vapor
import FluentProvider
@_exported import Models

/// Here, we take our shared Post model
/// and it's conformed to 
/// FluentProvider's `Model` protocol.
/// By conforming in this way,
/// we're extending our base shared models
/// to support Fluent functionality
/// in our ServerSide environment
extension Post: Model {
    /// Here, the storage property for conforming to 'Model'
    /// is added through our 'Extendable' protocol.
    /// This functionality allows us greater flexibility
    /// when sharing models across targets,
    /// without requiring complex inheritance
    public var storage: Storage {
        if let existing = extend["storage"] as? Storage {
            return existing
        } else {
            let new = Storage()
            extend["storage"] = new
            return new
        }
    }

    /// Our model will be initializing with a `Row`
    /// that is pulled from the database
    /// ... in our case, it matches exactly to our
    /// low level initializer so we can pass there
    /// if there was any specific requirements for 
    /// node, we could handle that special behavior here.
    public convenience init(row: Row) throws {
        try self.init(node: row)
    }

    /// Before saving our model to the database,
    /// it will ask for a 'Row' via this method
    /// to insert.
    /// Since 'id' is managed manually by fluent, 
    /// we're removing it from our base mapped 
    /// object.
    public func makeRow() throws -> Row {
        var row = try converted(in: rowContext) as Row
        row.removeKey("id")
        return row
    }
}

// MARK: Fluent Preparation

/// By conforming to `Preparation`
/// we're going to help notify the database
/// about _how_ it should store our `Post`
/// models.
extension Post: Preparation {
    /// Prepares a table/collection in the database
    /// for storing Posts.
    /// This will be handled automatically for you,
    /// when running Vapor. Alternatively, to call explicitly
    /// use the `vapor run prepare` command
    /// note: make sure you've called `'vapor build'` 
    /// to compile latest changes
    public static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string("content")
        }
    }

    /// Undoes what was done in `prepare`
    /// use `vapor run revert` to activate this.
    /// note: make sure you've called `'vapor build'`
    /// to compile latest changes
    public static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// MARK: HTTP

/// This allows Post models to be returned
/// directly in route closures.
/// In this case, the `Post` will automatically 
/// be converted to its `JSON` representation
/// unless something is more explicitly declared
/// via `makeResponse() throws -> Response`
extension Post: ResponseRepresentable { }
