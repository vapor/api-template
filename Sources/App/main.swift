import Vapor

let drop = Droplet()

drop.get { _ in
    return try drop.view.make("welcome")
}

drop.resource("posts", PostController())

drop.run()
