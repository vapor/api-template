import Fluent
import FluentSQLiteDriver
import FluentPostgresDriver
import FluentMySQLDriver
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }
    
    app.get("hello") { req in
        return "Hello, world!"
    }
    
    app.get("view") { req -> EventLoopFuture<View> in
        req.view.render("hello.txt", ["name": "world"])
    }
    
    app.get("db") { req -> EventLoopFuture<String> in
        MigrationLog.query(on: req.db)
            .all()
            .map { "\($0)" }
    }

    app.get("sql") { req -> EventLoopFuture<String> in
        (req.db as! SQLDatabase)
            .select().column("*")
            .from("fluent")
            .all()
            .map { "\($0)" }
    }

    app.get("postgres") { req -> EventLoopFuture<String> in
        (req.db as! PostgresDatabase)
            .query("SELECT * FROM fluent")
            .map { "\($0)" }
    }

    app.get("sqlite") { req -> EventLoopFuture<String> in
        (req.db as! SQLiteDatabase)
            .query("SELECT * FROM fluent")
            .map { "\($0)" }
    }

    app.get("mysql") { req -> EventLoopFuture<String> in
        (req.db as! MySQLDatabase)
            .query("SELECT * FROM fluent")
            .map { "\($0)" }
    }
    
    app.get("email") { req in
        req.jobs.dispatch(Email.self, .init(to: "tanner@vapor.codes"))
            .map { HTTPStatus.ok }
    }

    let todoController = TodoController()
    app.get("todos", use: todoController.index)
    app.post("todos", use: todoController.create)
    app.on(.DELETE, "todos", ":todoID", use: todoController.delete)
}
