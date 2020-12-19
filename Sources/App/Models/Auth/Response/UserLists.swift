//
//  File.swift
//  
//
//  Created by Vladimir Anisimov on 18.12.2020.
//

import Vapor
import Fluent

final class UserLists: Model, Content {
    
    static var schema: String = "user_lists"
    
    enum FieldKeys {
        static var userId: FieldKey = "user_id"
        static var listId: FieldKey = "list_id"
    }
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: FieldKeys.userId)
    var user: User
    
    @Parent(key: FieldKeys.listId)
    var list: ShoppingList
    
    init() {
        
    }
    
    init(listId: UUID, userId: UUID) {
        self.$list.id = listId
        self.$user.id = userId
    }
}
