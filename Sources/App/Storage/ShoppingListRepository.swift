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
    func remove(_ ownerId: UUID, listId: UUID) -> EventLoopFuture<Void>
}

struct DatabaseShoppingListRepository: ShoppingListRepository, DatabaseRepository {
   

    var database: Database
    
    func create(_ owner: User, list: ShoppingList) -> EventLoopFuture<ShoppingList> {
        return list.create(on: database)
            .flatMap { _ in
                owner.$allLists.attach(list, on: database)
            }
            .transform(to: list)
    }
    
    func remove(_ ownerId: UUID, listId: UUID) -> EventLoopFuture<Void> {
        let shoppingList = ShoppingList.query(on: database)
            .filter(\._$id == listId)
            .join(User.self, on: \ShoppingList.$owner.$id ==  \User.$id)
            .filter(User.self, \.$id == ownerId)
            .first()
            .unwrap(or: Abort(.badRequest))
            .map {
                $0.delete(on: database)
            }
            .transform(to: ())
            
            
        return shoppingList
            
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
