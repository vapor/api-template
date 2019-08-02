import Fluent
import Vapor

final class Todo: Model, Content {
    @Field var id: Int?
    @Field var title: String

    init() { }

    init(id: Int? = nil, title: String) {
        self.id = id
        self.title = title
    }
}
