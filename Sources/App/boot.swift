import Vapor

/// Called after your application has initialized.
public func boot(_ app: Application) throws {
    // your code here
    LoggingSystem.bootstrap(console: Terminal())
}
