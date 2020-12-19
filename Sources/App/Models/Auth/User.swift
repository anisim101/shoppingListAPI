//
//  File.swift
//  
//
//  Created by Vladimir Anisimov on 06.12.2020.
//

import Foundation
import Vapor
import Fluent
import FluentPostgresDriver
import JWT

final class User: Model, Content, UserInfoProtocol {
    
    enum FieldKeys {
        static var email: FieldKey = "email"
        static var hashPassword: FieldKey = "hash_password"
        static var avatarImageKey: FieldKey = "avatar_image_key"
        static var firstName: FieldKey = "first_name"
        static var secondName: FieldKey = "second_name"
    }

    static var schema: String = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: FieldKeys.email)
    var email: String
    
    @Field(key: FieldKeys.hashPassword)
    var hashPassword: String
    
    @Field(key: FieldKeys.firstName)
    var firstName: String?
    
    @Field(key: FieldKeys.secondName)
    var secondName: String?
    
    @Field(key: FieldKeys.avatarImageKey)
    var avatarImageKey: String?
    
    
    @Siblings(through: UserLists.self, from: \.$user, to: \.$list)
    var allLists: [ShoppingList]
    
    @Children(for: \.$owner)
    var userLists: [ShoppingList]
    
    required init() { }
    
    init(email: String, hashPassword: String,
         avatarImageKey: String? = nil,
         firstName: String? = nil,
         secondName: String? = nil) {
        self.email = email
        self.hashPassword = hashPassword
        self.firstName = firstName
        self.secondName = secondName
        self.avatarImageKey = avatarImageKey
    }
    
    
    func getToken(_ req: Request) throws -> String {
        let payload = TestPayload(expiration: .init(value: .distantFuture), user: self)
        
        return try req.jwt.sign(payload)
        
    }
}


extension User: Authenticatable {
    
}


extension User {
    static func auth(req: Request) throws -> EventLoopFuture<User> {
        let email =  try req.jwt.verify(as: TestPayload.self).user.email
        return req.users.find(email: email)
            .unwrap(or: Abort(.unauthorized))
        
    }
}
