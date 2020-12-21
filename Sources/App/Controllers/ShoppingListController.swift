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
            $0.delete(":list_id", use: deleteList)
        })
    }
    
    private func createList(_ req: Request) throws -> EventLoopFuture<SuccessResponseModel<ShoppingList>> {
        guard let request = try? req.content.decode(NewShoppingListRequest.self) else {
            throw RequestError.invalidJson
        }
        return  try User.auth(req: req)
            .flatMap { user in
                req.shoppingLists.create(user, list: ShoppingList.from(request, owner: user))
                    .map {SuccessResponseModel(data: $0) }
            }
    }
    
        private func deleteList(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
    
            guard let listIdString = req.parameters.get("list_id"),
                  let listUUID = UUID(uuidString: listIdString) else {
                throw RequestError.wrongRequest
            }
            
            return try  User.auth(req: req)
                .map { $0.id }
                .unwrap(or: InternalError.internalError)
                .map { userId in
                    req.shoppingLists.remove(userId, listId: listUUID)
                }
                .transform(to: .ok)
        }
    
}
