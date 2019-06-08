import Vapor

/// Creates an instance of `Application`. This is called from `main.swift` in the run target.
public func app(_ environment: Environment) throws -> Application {
    let app = Application.init(environment: environment) { s in
        try configure(&s)
    }
    try boot(app)
    return app
}
