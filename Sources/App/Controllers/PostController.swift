import Vapor
import HTTP

/// Here we have a controller that helps facilitate
/// RESTful interactions with our Posts table
final class PostController: ResourceRepresentable {
    /// When users call 'GET' on '/posts'
    /// it should return an index of all available posts
    func index(request: Request) throws -> ResponseRepresentable {
        return try Post.all().makeJSON()
    }

    /// When consumers call 'POST' on '/posts' with valid JSON
    /// create and save the post
    func create(request: Request) throws -> ResponseRepresentable {
        let post = try request.post()
        try post.save()
        return post
    }

    /// When the consumer calls 'GET' on a specific resource, ie:
    /// '/posts/13rd88' we should show that specific post
    func show(request: Request, post: Post) throws -> ResponseRepresentable {
        return post
    }

    /// When the consumer calls 'DELETE' on a specific resource, ie:
    /// 'posts/l2jd9' we should remove that resource from the database
    func delete(request: Request, post: Post) throws -> ResponseRepresentable {
        try post.delete()
        return Response(status: .ok)
    }

    /// When the consumer calls 'DELETE' on the entire table, ie:
    /// '/posts' we should remove the entire table
    func clear(request: Request) throws -> ResponseRepresentable {
        try Post.makeQuery().delete()
        return Response(status: .ok)
    }

    /// When the user calls 'PATCH' on a specific resource, we should
    /// update that resource to the new values
    func update(request: Request, post: Post) throws -> ResponseRepresentable {
        let new = try request.post()
        post.content = new.content
        try post.save()
        return post
    }

    /// When a user calls 'PUT' on a specific resource, we should
    /// delete the current value and completely replace it with the
    /// new parameters
    func replace(request: Request, post: Post) throws -> ResponseRepresentable {
        try post.delete()
        return try create(request: request)
    }

    /// When making a controller, it is pretty flexible in that it
    /// only expects closures, this is useful for advanced scenarios, but
    /// most of the time, it should look almost identical to this 
    /// implementation
    func makeResource() -> Resource<Post> {
        return Resource(
            index: index,
            store: create,
            show: show,
            update: update,
            replace: replace,
            destroy: delete,
            clear: clear
        )
    }
}

extension Request {
    /// Create a post from the JSON body
    /// return BadRequest error if invalid 
    /// or no JSON
    func post() throws -> Post {
        guard let json = json else { throw Abort.badRequest }
        return try Post(json: json)
    }
}

/// Since PostController doesn't require anything to 
/// be initialized we can conform it to EmptyInitializable.
///
/// This will allow it to be passed by type.
extension PostController: EmptyInitializable { }
