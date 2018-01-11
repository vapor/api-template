import App
import Service
import Vapor
import COperatingSystem // Remove this when Xcode bug is fixed

var config = Config.default()
var env = Environment.detect()
var services = Services.default()

do {
    try App.configure(&config, &env, &services)

    let app = try Application(
        config: config,
        environment: env,
        services: services
    )

    try App.boot(app)

    try app.run()
} catch {
    // Xcode 9.1 crashes sometimes when top level errors are thrown.
    // This can be removed when that bug is fixed.
    print(error)
    exit(1)
}
