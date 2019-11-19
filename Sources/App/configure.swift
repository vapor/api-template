import Fluent
import FluentMySQLDriver
import FluentPostgresDriver
import FluentSQLiteDriver
import Vapor
import Leaf

// Called before your application boots after initialization.
public func configure(_ app: Application) throws {
    // Register providers first
    app.use(Fluent.self)
    app.use(Leaf.self)

    // Register middleware
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    app.databases.use(.sqlite(file: "db.sqlite"), as: .sqlite)
    app.databases.use(.postgres(
        hostname: "localhost",
        username: "vapor_username",
        password: "vapor_password",
        database: "vapor_database"
    ), as: .psql)
    app.databases.use(.mysql(
        hostname: "localhost",
        username: "vapor_username",
        password: "vapor_password",
        database: "vapor_database"
    ), as: .default)
    app.databases.middleware.use(TodoMiddleware(), on: .sqlite)
    app.migrations.add(CreateTodo(), to: .default)
    app.directory.viewsDirectory = app.directory.publicDirectory
    
    app.sessions.use(database: .sqlite)
    
    try routes(app)
}

struct TodoMiddleware: ModelMiddleware {
    typealias Model = Todo
}
