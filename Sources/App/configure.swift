import Fluent
import FluentPostgresDriver
import Vapor

/// Called before your application initializes.
public func configure(_ s: inout Services) throws {
    /// Register providers first
    try s.provider(FluentProvider())

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
    
    s.register(FluentDatabases.self) { c in
        var dbs = FluentDatabases()
        let psql = try c.make(PostgresDatabase.self)
        let pool = try psql.makeConnectionPool(config: c.make(ConnectionPoolConfig.self))
        dbs.add(pool, as: .psql)
        return dbs
    }
    
    s.register(FluentMigrations.self) { c in
        var migrations = FluentMigrations()
        migrations.add(Todo.autoMigration(), to: .psql)
        return migrations
    }
}

extension Container {
    func connectionPool<D>(for dbid: DatabaseIdentifier<D>) throws -> ConnectionPool<D> {
        return try self.make(ThreadConnectionPool.self).get(for: dbid)
    }
}

extension FluentDatabaseID {
    static var psql: FluentDatabaseID {
        return FluentDatabaseID(string: "psql")
    }
}
