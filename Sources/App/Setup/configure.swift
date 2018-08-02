import FluentSQLite
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    /// Register providers first
    try services.register(FluentSQLiteProvider())

    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    /// Register middlewares
    var middlewaresConfig = MiddlewareConfig() // Create _empty_ middleware config
    try middlewares(config: &middlewaresConfig)
    services.register(middlewaresConfig)

    /// Register databases.
    var databasesConfig = DatabasesConfig()
    try databases(config: &databasesConfig)
    services.register(databasesConfig)

    /// Register migrations
    var migrationsConfig = MigrationConfig()
    migrate(config: &migrationsConfig)
    services.register(migrationsConfig)

    /// Register Repositories
    setupRepositories(&config, &env, &services)

    /// Register Content Config
    var contentConfig = ContentConfig.default()
    try content(config: &contentConfig)
    services.register(contentConfig)

    /// Register Commands
    var commandsConfig = CommandConfig.default()
    commands(config: &commandsConfig)
    services.register(commandsConfig)
}
