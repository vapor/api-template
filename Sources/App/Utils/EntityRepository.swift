import FluentSQLite
import Vapor

protocol ModelRepository: Service {
    associatedtype M: Model
    
    func count(on conn: DatabaseConnectable) -> Future<Int>
    
    func find(id: M.ID, on conn: DatabaseConnectable) -> Future<M?>
    
    func findAll(on conn: DatabaseConnectable) -> Future<[M]>
    
    func save(model: M, on connectable: DatabaseConnectable) -> Future<M>
}

extension ModelRepository {
    func count(on connectable: DatabaseConnectable) -> Future<Int> {
        return M.query(on: connectable).count()
    }
    
    func find(id: M.ID, on connectable: DatabaseConnectable) -> Future<M?> {
        return M.find(id, on: connectable)
    }
    
    func findAll(on connectable: DatabaseConnectable) -> Future<[M]> {
        return M.query(on: connectable).all()
    }
    
    func save(model: M, on connectable: DatabaseConnectable) -> Future<M> {
        return model.save(on: connectable)
    }
}
