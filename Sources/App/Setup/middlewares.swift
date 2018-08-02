import Vapor

public func middlewares(config: inout MiddlewareConfig) throws {
    // config.use(FileMiddleware.self) // Serves files from `Public/` directory
    config.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    // Other Middlewares...
}