import Vapor

/// Creates an instance of `Application`. This is called from `main.swift` in the run target.
public func app(_ env: Environment) throws -> Application {
    let app = Application.init(env: env) {
        var s = Services.default()
        try configure(&s)
        return s
    }
    try boot(app)
    return app
}
