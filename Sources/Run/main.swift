import App

let app = try App(env: .detect())
try app.run().wait()
try app.cleanup()
