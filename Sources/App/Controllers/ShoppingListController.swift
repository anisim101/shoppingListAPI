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
            $0.post("addMember", use: addMember)
        })
    }
    
    private func addMember(_ req: Request) throws -> EventLoopFuture<SuccessResponseModel<ShoppingList>> {
        guard let request = try? req.content.decode(AddMemberToListRequest.self) else {
            throw RequestError.invalidJson
        }
        
        let currentUser = try User.auth(req: req)
        let member = req.users.find(id: request.memberId)
             .unwrap(orError: RequestError.wrongRequest)
       
        let list = req.shoppingLists.getList(listId: request.listId)
            .unwrap(orError: RequestError.wrongRequest)
        
        return currentUser.flatMap { currentUser in
            list
                .guard({ $0.$owner.id == currentUser.id }, else: AuthenticationError.noPermission) // not owner
                .flatMap { list in
                    req.users.listMember(list)
                }
                .and(member)
                .guard({ members, member in
                        !members.contains(where: { $0.id == member.id }) }, else: ListError.alreadyMember) // already member
                .flatMap { _ in list }
                .flatMap { list in
                    member.flatMap { member in
                        req.shoppingLists.addMember(to: list, member: member)
                    }
                    .map { _ in list}
                }
            
        }
        .map { SuccessResponseModel(data: $0) }
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
    
        private func deleteList(_ req: Request) throws -> EventLoopFuture<SuccessResponse> {
    
            guard let listUUID: UUID = req.parameters.get("list_id") else {
                throw RequestError.wrongRequest
            }
            
            return  try  User.auth(req: req)
                .map { $0.id }
                .unwrap(or: InternalError.internalError)
                .flatMap { userId in
                   return req.shoppingLists.remove(userId, listId: listUUID)
                }
                .guard({ $0 == nil }, else: RequestError.wrongRequest )
                .map { _ in
                    return SuccessResponse()
                }
        
                
        }
    
}
