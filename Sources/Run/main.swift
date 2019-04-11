import App

let app = try App.app(.detect())
defer { app.shutdown() }
try app.run()
