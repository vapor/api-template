import FluentSQLite

public func databases(config: inout DatabasesConfig) throws {
    let sqlite = try SQLiteDatabase(storage: .memory)

    config.add(database: sqlite, as: .sqlite)
}
