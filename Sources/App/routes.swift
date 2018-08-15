import Authentication
import Vapor
import JWT

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    router.get("hello") { req -> String in
        // fetches the token from `Authorization: Bearer <token>` header
        guard let bearer = req.http.headers.bearerAuthorization else {
            throw Abort(.unauthorized)
        }
        // parse JWT from token string, using HS-256 signer
        let jwt = try JWT<User>(from: bearer.token, verifiedUsing: .hs256(key: "secret"))
        return "Hello, \(jwt.payload.name)."
    }
    
    router.get("middleware") { req -> String in
        let user = try req.requireAuthenticated(User.self)
        return "Hello, \(user.name)."
    }
    
    router.get("login") { req -> String in
        let user = User(id: 42, name: "Vapor Developer")
        let data = try JWT(payload: user).sign(using: .hs256(key: "secret"))
        return String(data: data, encoding: .utf8) ?? ""
    }
}

final class JWTAuthenticationMiddleware<U>: Middleware where U: Authenticatable & JWTPayload {
    let signer: JWTSigner

    init(_ type: U.Type, signer: JWTSigner) {
        self.signer = signer
    }
    
    /// See `Middleware`.
    func respond(to req: Request, chainingTo next: Responder) throws -> EventLoopFuture<Response> {
        // fetches the token from `Authorization: Bearer <token>` header
        guard let bearer = req.http.headers.bearerAuthorization else {
            // no authorization header, pass along un-authenticated request
            return try next.respond(to: req)
        }
        
        // parse JWT from token string, using configured signer
        let jwt = try JWT<U>(from: bearer.token, verifiedUsing: signer)
        try req.authenticate(jwt.payload)
        
        // pass along authenticated request
        return try next.respond(to: req)
    }
}

struct User: JWTPayload, Authenticatable {
    var id: Int
    var name: String

    func verify(using signer: JWTSigner) throws {
        // nothing to verify
    }
}
