import Routing
import Vapor

/// Called after your application has initialized.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#bootswift)
public func boot(_ app: Application) throws {
    // register routes
    let router = try app.make(Router.self)
    let routes = Routes(app: app)
    try router.register(collection: routes)

    // your code here
}
