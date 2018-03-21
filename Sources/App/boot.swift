import Routing
import Vapor

/// Called after your application has initialized.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#bootswift)
public func boot(_ app: Application) throws {
    // your code here

    let conn = try app.requestConnection(to: .sqlite).wait()
    defer { app.releaseConnection(conn, to: .sqlite) }

    for _ in 0..<1_000 {
        _ = try Todo(title: "Hello World").save(on: conn).wait()
    }
}
