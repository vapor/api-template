import DatabaseKit
import PostgresKit
import FluentPostgresDriver
import Vapor

/// Called before your application initializes.
public func configure(_ s: inout Services) throws {
    /// Register providers first
    #warning("TODO: update Fluent provider")
    // try services.register(FluentSQLiteProvider())

    /// Register routes
    s.extend(Routes.self) { r, c in
        try routes(r, c)
    }

    /// Register middleware
    s.register(MiddlewareConfig.self) { c in
        // Create _empty_ middleware config
        var middlewares = MiddlewareConfig()
        
        // Serves files from `Public/` directory
        /// middlewares.use(FileMiddleware.self)
        
        // Catches errors and converts to HTTP response
        try middlewares.use(c.make(ErrorMiddleware.self))
        
        return middlewares
    }
    
    s.register(PostgresDatabase.Config.self) { c in
        return .init(
            hostname: "localhost",
            username: "vapor_username",
            password: "vapor_password",
            database: "vapor_database"
        )
    }
    
    s.register(ConnectionPoolConfig.self) { c in
        return .init(maxConnections: 12)
    }
    
    s.register(ThreadConnectionPool.self) { c in
        return try .init(databases: c.make(), config: c.make())
    }
    
    s.register(PostgresDatabase.self) { c in
        return try PostgresDatabase(config: c.make(), on: c.eventLoop)
    }

    /// Register the configured SQLite database to the database config.
    s.register(Databases.self) { c in
        var databases = Databases()
        try databases.add(database: c.make(PostgresDatabase.self), as: .psql)
        return databases
    }

    #warning("TODO: update migrations config")
//    /// Configure migrations
//    var migrations = MigrationConfig()
//    migrations.add(model: Todo.self, database: .sqlite)
//    services.register(migrations)

}

extension Container {
    func connectionPool<D>(for dbid: DatabaseIdentifier<D>) throws -> ConnectionPool<D> {
        return try self.make(ThreadConnectionPool.self).get(for: dbid)
    }
}

extension DatabaseIdentifier {
    static var psql: DatabaseIdentifier<PostgresDatabase> {
        return "psql"
    }
}
