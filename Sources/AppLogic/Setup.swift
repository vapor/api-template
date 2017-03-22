@_exported import Vapor
import VaporLeaf
import VaporFluent

public func setup(_ drop: Droplet) throws {
    try setupProviders(drop)
    try setupModels(drop)
    try setupRoutes(drop)
    try setupResources(drop)
}

private func setupProviders(_ drop: Droplet) throws {
    try drop.addProvider(VaporLeaf.Provider.self)

    let fluent = VaporFluent.Provider()
    try drop.addProvider(fluent)
}

private func setupModels(_ drop: Droplet) throws {
    drop.preparations += [
        Post.self
    ]
}

private func setupRoutes(_ drop: Droplet) throws {
    drop.get { req in
        let message = drop.localization[req.lang, "welcome", "title"]
        return try drop.view.make("welcome", ["message": message])
    }
}

private func setupResources(_ drop: Droplet) throws {
    drop.resource("posts", PostController())
}
