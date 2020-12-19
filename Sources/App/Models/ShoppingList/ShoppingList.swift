//
//  File.swift
//  
//
//  Created by Vladimir Anisimov on 06.12.2020.
//

import Vapor
import Fluent


final class ShoppingList: Model, Content {
    
    static var schema: String = "shopping_lists"
    
    enum FieldKeys {
        static let listName: FieldKey = "list_name"
        static let listImageKey: FieldKey = "list_image_key"
        static let creatingDate: FieldKey = "creating_date"
        static let ownerId: FieldKey = "owner_id"
    }
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: FieldKeys.listName)
    var listName: String

    @Field(key: FieldKeys.listImageKey)
    var listImageKey: String
    
    @Field(key: FieldKeys.creatingDate)
    var creatingDate: Date
    
    @Siblings(through: UserLists.self, from: \.$list, to: \.$user)
    var members: [User]
    
    @Parent(key: FieldKeys.ownerId)
    var owner: User

    
    init() { }

    init(id: UUID? = nil,
         listName: String,
         listImageKey: String,
         creatingDate: Date, ownerId: UUID) {
        self.id =  id
        self.listName = listName
        self.listImageKey = listImageKey
        self.creatingDate = creatingDate
        self.$owner.id = ownerId
    }
}

extension ShoppingList {
   static func from(_ request: NewShoppingListRequest, owner: User) -> ShoppingList {
        return ShoppingList(listName: request.listName,
                            listImageKey: request.listImageKey,
                            creatingDate: Date(), ownerId: owner.id!)
    }
}
