import Routing
import Vapor

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
final class Routes: RouteCollection {
    /// Create a new Routes collection with
    /// the supplied application.
    init() {}

    /// See RouteCollection.boot
    func boot(router: Router) throws {
        router.get("hello") { req in
            return "Hello, world!"
        }
    }
}
