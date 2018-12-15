import App

let app = try App.app(.detect())
try app.run().wait()
try app.runningServer?.onClose.wait()
