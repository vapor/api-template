import HTTP
import Vapor
import Routing

final class ApiCollection : RouteCollection, EmptyInitializable {
    typealias Wrapped = HTTP.Responder
    
    init() {}
    
    func build<Builder : RouteBuilder>(_ builder: Builder) where Builder.Value == Responder {
        builder.get("/api/hello") { req in
            return JSON([
                "result": "ok",
                "message": try Node(node: [
                    "from": "admin",
                    "payload": "Hello, world!"
                ])
            ])
        }
    }
}
