import Vapor
import FluentSQLite

class TodoRepository: ModelRepository {
    typealias M = Todo
    
    func find(title: String, on connectable: DatabaseConnectable) -> Future<Todo?> {
        return Todo.query(on: connectable).filter(\Todo.title == title).first()
    }
    
    func findCount(title: String, on connectable: DatabaseConnectable) -> Future<Int> {
        return Todo.query(on: connectable).filter(\Todo.title == title).count()
    }
}
