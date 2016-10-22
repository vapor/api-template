import Vapor

func configureDroplet() throws -> Droplet {
    let drop = Droplet()

    drop.get { req in
        return try drop.view.make("welcome", [
    	    "message": drop.localization[req.lang, "welcome", "title"]
        ])
    }

    drop.resource("posts", PostController())

    return drop
}
