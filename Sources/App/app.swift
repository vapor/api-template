import Vapor

public func app(_ environment: Environment) throws -> Application {
    var environment = environment
    try LoggingSystem.bootstrap(from: &environment)
    let app = Application(environment)
    try! configure(app)
    try app.boot()
    try! boot(app)
    return app
}
