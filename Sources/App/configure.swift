import Authentication
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    /// Register providers first
    try services.register(AuthenticationProvider())

    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    /// Register middleware
    services.register { container -> MiddlewareConfig in
        // Create _empty_ middleware config
        var middlewares = MiddlewareConfig()
        // Authorizes request using JWT, if present
        let jwt = JWTAuthenticationMiddleware(User.self, signer: .hs256(key: "secret"))
        middlewares.use(jwt)
        // Catches errors and converts to HTTP response
        middlewares.use(ErrorMiddleware.self)
        return middlewares
    }

//    // Configure a SQLite database
//    let sqlite = try SQLiteDatabase(storage: .memory)
//
//    /// Register the configured SQLite database to the database config.
//    var databases = DatabasesConfig()
//    databases.add(database: sqlite, as: .sqlite)
//    services.register(databases)
//
//    /// Configure migrations
//    var migrations = MigrationConfig()
//    migrations.add(model: Todo.self, database: .sqlite)
//    services.register(migrations)

}
