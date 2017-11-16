import App
import Service
import Vapor

let config = Config.default()
let env = Environment.detect()
let services = Services.default()

try App.configure(config, env, services)

let app = try Application(
    config: config,
    environment: env,
    services: services
)

try App.boot(app)

try app.run()
