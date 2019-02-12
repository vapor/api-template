import App

try app(.detect())
    .run().wait()
    .cleanup()
