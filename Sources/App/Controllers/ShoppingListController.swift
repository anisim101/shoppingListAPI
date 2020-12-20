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
    
}
