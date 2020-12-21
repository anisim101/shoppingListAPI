//
//  File.swift
//  
//
//  Created by Vladimir Anisimov on 18.12.2020.
//

import Vapor
import Fluent

struct CreateUserLists: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(UserLists.schema)
            .id()
//            .field(UserLists.FieldKeys.listId,
//                   .uuid,
//                   .required,
//                   .references(ShoppingList.schema, .id))
            
            .field(UserLists.FieldKeys.listId,
                   .uuid,
                   .required)
            .foreignKey(UserLists.FieldKeys.listId, references: ShoppingList.schema, .id, onDelete: .cascade)
            
            
            
            
            
//            .field(UserLists.FieldKeys.userId,
//                   .uuid,
//                   .required,
//                   .references(User.schema, .id))
            
            
            .field(UserLists.FieldKeys.userId,
                   .uuid,
                   .required)
            .foreignKey(UserLists.FieldKeys.userId, references: User.schema, .id, onDelete: .cascade)
            
            
            
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(UserLists.schema).delete()
    }
}
