//
//  File.swift
//  
//
//  Created by Vladimir Anisimov on 18.12.2020.
//

import Vapor
import Fluent

class ShoppingListController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.group("lists", configure: {
            $0.post("create", use:  createList)
//            $0.delete("delete", use: deleteList)
        })
    }
    
    private func createList(_ req: Request) throws -> EventLoopFuture<ShoppingList> {
        
        let request = try req.content.decode(NewShoppingListRequest.self)
        return  try User.auth(req: req)
            .flatMap { user in
                req.shoppingLists.create(user, list: ShoppingList.from(request, owner: user))
                
            }
    }
    
//    private func deleteList(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
//
//        guard let listId = try req.parameters.get("list_id") else {
//            Abort(.badRequest)
//
//        }
//        return try  User.auth(req: req)
//            .map { user in
//                req.shoppingLists.remove(user.id!, listId: UUID(uuidString: listId))
//            }
//            .transform(to: .ok)
//    }
}
