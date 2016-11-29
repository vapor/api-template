import Vapor

let drop = Droplet()

drop.collection(ApiCollection.self)

drop.run()
