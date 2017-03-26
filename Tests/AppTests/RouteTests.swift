import HTTP
import Vapor
import XCTest

@testable import App

class RouteTests: XCTestCase {
    static var drop: Droplet {
        let drop = Droplet()
        drop.collection(ApiCollection.self)
        return drop
    }
    
    func testApiHelloJSON() {
        let request = try! Request(method: .get, uri: "/api/hello")
        let response = try! RouteTests.drop.respond(to: request)
        
        guard let json = response.json else {
            XCTFail("expected json response.")
            return
        }
        
        guard let result = json["result"]?.string else {
            XCTFail("expected a string named `result`.")
            return
        }
        
        guard let message = json["message"]?.object else {
            XCTFail("expected an object named `message`.")
            return
        }
        
        guard let from = message["from"]?.string else {
            XCTFail("expected a string named `from` inside of `message`.")
            return
        }
        
        guard let payload = message["payload"]?.string else {
            XCTFail("expected a string named `payload` inside of `message`.")
            return
        }
        
        XCTAssertEqual(result, "ok")
        XCTAssertEqual(from, "admin")
        XCTAssertEqual(payload, "Hello, world!")
    }
}
