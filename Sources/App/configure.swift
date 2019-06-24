import Fluent
import FluentSQLiteDriver
import Jobs
import JobsRedisDriver
import Redis
import Vapor

struct FooJob: Job {
    init() { }

    struct FooData: JobData {
        var foo: String
    }

    func dequeue(_ context: JobContext, _ data: FooData) -> EventLoopFuture<Void> {
        print(data)
        return context.eventLoop.future()
    }

    func error(_ context: JobContext, _ error: Error, _ data: FooData) -> EventLoopFuture<Void> {
        print(error)
        return context.eventLoop.future()
    }
}

/// Called before your application initializes.
func configure(_ s: inout Services) throws {
    /// Register providers first
    s.provider(FluentProvider())
    s.provider(JobsProvider())
    s.provider(RedisProvider())

    /// Register routes
    s.extend(Routes.self) { r, c in
        try routes(r, c)
    }

    // register jobs presistence layer
    s.register(JobsDriver.self) { c in
        return try JobsRedisDriver(client: c.make())
    }

    s.extend(JobsConfiguration.self) { config, c in
        config.add(FooJob())
    }

    /// Register middleware
    s.register(MiddlewareConfiguration.self) { c in
        // Create _empty_ middleware config
        var middlewares = MiddlewareConfiguration()
        
        // Serves files from `Public/` directory
        /// middlewares.use(FileMiddleware.self)
        
        // Catches errors and converts to HTTP response
        try middlewares.use(c.make(ErrorMiddleware.self))
        
        return middlewares
    }
    
    s.extend(Databases.self) { dbs, c in
        try dbs.sqlite(configuration: c.make(), threadPool: c.make())
    }

    s.register(SQLiteConfiguration.self) { c in
        return .init(storage: .connection(.file(path: "db.sqlite")))
    }

    s.register(Database.self) { c in
        return try c.make(Databases.self).database(.sqlite)!
    }
    
    s.register(Migrations.self) { c in
        var migrations = Migrations()
        migrations.add(CreateTodo(), to: .sqlite)
        return migrations
    }
}
