@_exported import Vapor

extension Droplet {
    /// We have a setup function here 
    /// so that we can abstract away the 
    /// droplet's setup without putting it
    /// in our executable.
    /// This is done to help facilitate 
    /// testing.
    public func setup() throws {
        try collection(Routes.self)
    }
}
