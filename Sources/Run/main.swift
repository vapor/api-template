import App
import Foundation

// The contents of main are wrapped in a do/catch block because any errors that get raised to the top level will crash Xcode
do {
    let app = try App.bootstrap()

    try app.run()
} catch {
    print(error)
    exit(1)
}
