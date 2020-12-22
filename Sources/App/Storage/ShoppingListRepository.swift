//
//  File.swift
//  
//
//  Created by Vladimir Anisimov on 19.12.2020.
//

import Vapor
import Fluent

protocol ShoppingListRepository: Repository {
    func create(_ owner: User, list: ShoppingList) -> EventLoopFuture<ShoppingList>
    func remove(_ ownerId: UUID, listId: UUID) -> EventLoopFuture<Error?>
    func addMember(to list: ShoppingList, member: User) -> EventLoopFuture<Void> 
    func getList(listId: UUID) -> EventLoopFuture<ShoppingList?>
}

struct DatabaseShoppingListRepository: ShoppingListRepository, DatabaseRepository {
    
    
    var database: Database
    
    func create(_ owner: User, list: ShoppingList) -> EventLoopFuture<ShoppingList> {
        return list.create(on: database)
            .flatMap { _ in
                owner.$allLists.attach(list, on: self.database)
            }
            .transform(to: list)
    }
    
    func remove(_ ownerId: UUID, listId: UUID) -> EventLoopFuture<Error?> {
        let shoppingList = ShoppingList.query(on: database)
            .filter(\._$id == listId)
            .join(User.self, on: \ShoppingList.$owner.$id ==  \User.$id)
            .filter(User.self, \.$id == ownerId)
            .first()
            .flatMap { list -> EventLoopFuture<Error?> in
                if let list = list {
                    return list.delete(on: self.database)
                        .map { nil }
                }
                return self.database.eventLoop.makeSucceededFuture(RequestError.wrongRequest)
            }
        return shoppingList
    }
    
    func getList(listId: UUID) -> EventLoopFuture<ShoppingList?> {
        return ShoppingList.find(listId, on: database)
        
    }
    
    func addMember(to list: ShoppingList, member: User) -> EventLoopFuture<Void> {
        return member.$allLists.attach(list, on: database)
    }
}

extension DatabaseShoppingListRepository {
    func `for`(_ req: Request) -> Self {
        return Self.init(database: req.db)
    }
}

extension Application.Repositories {
    var shoppingLists: ShoppingListRepository {
        guard let storage = storage.makeShoppingListRepository else {
            fatalError("UserRepository not configured, use: app.shoppingLists.use()")
        }
        
        return storage(app)
    }
    
    func use(_ make: @escaping (Application) -> (ShoppingListRepository)) {
        storage.makeShoppingListRepository = make
    }
}
