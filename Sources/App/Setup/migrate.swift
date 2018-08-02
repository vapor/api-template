import FluentSQLite

public func migrate(config: inout MigrationConfig) {
    config.add(model: Todo.self, database: .sqlite)
}
