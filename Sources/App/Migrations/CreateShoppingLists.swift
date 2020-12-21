//
//  File.swift
//  
//
//  Created by Vladimir Anisimov on 06.12.2020.
//

import Foundation

import Fluent

struct CreateShoppingLists: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(ShoppingList.schema)
            .id()
            .field(ShoppingList.FieldKeys.listName, .string, .required)
            .field(ShoppingList.FieldKeys.listImageKey, .string, .required)
            .field(ShoppingList.FieldKeys.creatingDate, .datetime, .required)
//            .foreignKey(ShoppingList.FieldKeys.ownerId, references: User.schema, .id, onDelete: .cascade)
            .field(ShoppingList.FieldKeys.ownerId,
                   .uuid,
                   .required,
                   .references(User.schema, .id))
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(ShoppingList.schema).delete()
    }
    
}
