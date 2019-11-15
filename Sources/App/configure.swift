import Fluent
import FluentMySQLDriver
import FluentPostgresDriver
import FluentSQLiteDriver
import Vapor

// Called before your application boots after initialization.
public func configure(_ app: Application) throws {
    // Register providers first
    app.provider(FluentProvider())

    // Register middleware
    app.register(extension: MiddlewareConfiguration.self) { middlewares, app in
        // Serves files from `Public/` directory
        // middlewares.use(app.make(FileMiddleware.self))
    }
    
    app.register(extension: Databases.self) { dbs, app in
        dbs.use(.sqlite(file: "db.sqlite"), as: .sqlite)
        dbs.use(.postgres(
            hostname: "localhost",
            username: "vapor_username",
            password: "vapor_password",
            database: "vapor_database"
        ), as: .psql)
        dbs.use(.mysql(
            hostname: "localhost",
            username: "vapor_username",
            password: "vapor_password",
            database: "vapor_database"
        ), as: .default)
        dbs.middleware.use(TodoMiddleware(), on: .sqlite)
    }
    
    app.register(extension: Migrations.self) { migrations, app in
        migrations.add(CreateTodo(), to: .default)
    }
    
    try routes(app)
}

struct TodoMiddleware: ModelMiddleware {
    typealias Model = Todo
}
