import Vapor

/// Creates an instance of `Application`. This is called from `main.swift` in the run target.
public func app(_ env: Environment) throws -> Application {
    let app = Application.init(environment: env) { s in
        try configure(&s)
    }
    try boot(app)
    return app
}
