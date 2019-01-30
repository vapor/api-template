#if(fluent) {
import Fluent#(fluentdb) }
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    #if(fluent) {
    /// Register providers first
    try services.register(Fluent#(fluentdb)Provider())
    }

    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    /// middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    #if(fluent) {
    /// Configure a #(fluentdb) database
    services.register #("{") c -> #(fluentdb)Database in
        #if(fluentdb == "SQLite") {
        return try #(fluentdb)Database(storage: .memory)
        } else {
        return try #(fluentdb)Database(config: c.make())
        }
    #("}")

    /// Register the configured #(fluentdb) database to the database config.
    services.register #("{") c -> DatabasesConfig in
        var databases = DatabasesConfig()
        #if(fluentdb == "SQLite") {
        try databases.add(database: c.make(#(fluentdb)Database.self), as: .sqlite)
        } else if (fluentdb == "PostgreSQL") {
        try databases.add(database: c.make(#(fluentdb)Database.self), as: .psql)
        } else if (fluentdb == "MySQL") {
        try databases.add(database: c.make(#(fluentdb)Database.self), as: .mysql)
        }
        return databases
    #("}")

    /// Configure migrations
    services.register #("{") c -> MigrationConfig in
        var migrations = MigrationConfig()
        #if(fluentdb == "SQLite") {
        migrations.add(model: Todo.self, database: .sqlite)
        } else if (fluentdb == "PostgreSQL") {
        migrations.add(model: Todo.self, database: .psql)
        } else if (fluentdb == "MySQL") {
        migrations.add(model: Todo.self, database: .mysql)
        }
        return migrations
    #("}")
    }
}
