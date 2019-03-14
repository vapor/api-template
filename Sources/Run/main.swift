import App

let app = try App.app(.detect())
defer { try! app.shutdown() }
_ = try app.run().wait()
