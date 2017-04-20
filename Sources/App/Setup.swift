@_exported import Vapor
import FluentProvider

extension Droplet {
    public func setup() throws {
        try collection(Routes.self)
    }
}

extension Config {
    public func setup() throws {
        try addProvider(FluentProvider.Provider.self)
        
        preparations += [
            Post.self
        ]
    }
}
