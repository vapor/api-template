import Vapor
import FluentProvider
import Foundation

final class Post: Model {
    let storage = Storage()
    var content: String

    // MARK: General Initializer

    init(content: String) {
        self.content = content
    }

    // MARK: Data Initializers

    convenience init(row: Row) throws {
        try self.init(node: row)
    }

    convenience init(json: JSON) throws {
        try self.init(node: json)
    }

    init(node: Node) throws {
        content = try node.get("content")
        id = try node.get(idKey)
    }

    // MARK: Data Constructors

    func makeRow() throws -> Row {
        return try makeNode(in: rowContext).converted()
    }

    func makeJSON() throws -> JSON {
        return try makeNode(in: jsonContext).converted()
    }

    func makeNode(in context: Context?) throws -> Node {
        var node = Node(context)
        try node.set(idKey, id)
        try node.set("content", content)
        return node
    }
}

extension Post: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id(for: self)
            builder.string("content")
        }
    }

    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}
