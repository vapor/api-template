import FluentProvider

extension Config {
    public func setup() throws {
        // allow fuzzy conversions for these types
        // (add your own types here)
        Node.fuzzy = [Row.self, JSON.self, Node.self]

        try setupProviders()
        try setupPreparations()
    }
    
    /// Configure providers
    private func setupProviders() throws {
        try addProvider(FluentProvider.Provider.self)
    }
    
    /// Add all models that should have their
    /// schemas prepared before the app boots
    private func setupPreparations() throws {
        /// Note, there is a bug in the Swift compiler when trying to use += 
        /// and an array of longer length than 1,
        /// use append on the preparations array to work around this.
        preparations.append(Post.self)
    }
}
