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
    
    s.extend(HTTPServer.Configuration.self) { config, c in
        config.supportVersions = [.one]
    }
    
    s.extend(Databases.self) { dbs, c in
        let url = Environment.get("DB_URL") ?? "postgres://vapor_username:vapor_password@localhost:5432/vapor_database"
        dbs.postgres(config: PostgresConfig(url: URL(string: url)!)!)
    }
    
    s.register(Migrations.self) { c in
        var migrations = Migrations()
        migrations.add(Todo.autoMigration(), to: .psql)
        return migrations
    }
}
