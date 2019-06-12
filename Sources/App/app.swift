import Vapor

public func app(_ environment: Environment) throws -> Application {
    let app = Application.init(environment: environment) { s in
        try configure(&s)
    }
    try boot(app)
    return app
}
