import APNS
import Fluent
import FluentMySQLDriver
import FluentPostgresDriver
import FluentSQLiteDriver
import JobsRedisDriver
import Jobs
import Leaf
import Vapor

// Called before your application boots after initialization.
public func configure(_ app: Application) throws {
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
    ), as: .mysql)
    app.databases.default(to: .mysql)
    app.databases.middleware.use(TodoMiddleware(), on: .sqlite)
    app.migrations.add(CreateTodo(), to: .sqlite)
    app.directory.viewsDirectory = app.directory.publicDirectory
    
    app.sessions.use(.fluent(.sqlite))
    
    try app.jobs.use(.redis(url: "redis://localhost:6379"))
    app.jobs.add(Email())
    
//    app.jobs.schedule(Test(name: "every second"))
//        .everySecond()
    
//    app.jobs.schedule(Test(name: "minutely at 5"))
//        .minutely()
//        .at(5)
//
//    app.jobs.schedule(Test(name: "hourly at 30 mins 0 seconds"))
//        .hourly()
//        .at(30)
//
//    app.jobs.schedule(Test(name: "daily"))
//        .daily()
//        .at("7:09pm")
    
    app.jobs.schedule(Test(name: "mondays at noon"))
        .weekly()
        .on(.monday)
        .at(.noon)
    
    app.jobs.schedule(Test(name: "monthly on the 2nd at noon"))
        .monthly()
        .on(2)
        .at(.noon)
    
    try routes(app)
}

struct TodoMiddleware: ModelMiddleware {
    typealias Model = Todo
}

struct Test: ScheduledJob {
    let name: String
    func run(context: JobContext) -> EventLoopFuture<Void> {
        context.logger.info("job \(self.name)!")
        return context.eventLoop.makeSucceededFuture(())
    }
}

struct Email: Job {
    struct Message: Codable {
        var to: String
    }
    
    func dequeue(_ context: JobContext, _ message: Message) -> EventLoopFuture<Void> {
        context.logger.info("sending email to \(message.to)")
        return context.eventLoop.makeSucceededFuture(())
    }
}
