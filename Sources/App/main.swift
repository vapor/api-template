import AppLogic

/// We have isolated all of our App's logic into
/// the AppLogic module because it makes our app 
/// more testable.
///
/// In general, the executable portion of our App
/// shouldn't include much more code than is presented
/// here.
///
/// We simply initialize our Droplet, optionally
/// passing in values if necessary
/// Then, we pass it to our AppLogic's setup function
/// this should setup all the routes and special
/// features of our app
///
/// .run() tells the drop to begin serving
let drop = try Droplet()
try AppLogic.setup(drop)
try drop.run()
