//
//  File.swift
//  
//
//  Created by Vladimir Anisimov on 06.12.2020.
//

import Foundation
import Vapor
import FluentKit
import FluentPostgresDriver

struct CreateUsers: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(User.schema)
            .id()
            .field(User.FieldKeys.email, .string, .required)
            .field(User.FieldKeys.hashPassword, .string, .required)
            .field(User.FieldKeys.firstName, .string)
            .field(User.FieldKeys.secondName, .string)
            .field(User.FieldKeys.avatarImageKey, .string)
            .unique(on: User.FieldKeys.email)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(User.schema).delete()
    }
}
