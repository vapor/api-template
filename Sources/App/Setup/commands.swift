import Vapor
import FluentSQLite

public func commands(config: inout CommandConfig) {
    config.useFluentCommands()
}
