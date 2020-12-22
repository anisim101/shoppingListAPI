//
//  File.swift
//  
//
//  Created by Vladimir Anisimov on 06.12.2020.
//

import Vapor
import Fluent


protocol UserRepository: Repository {
    func create(_ user: User) -> EventLoopFuture<Void>
    func find(id: UUID?) -> EventLoopFuture<User?>
    func find(email: String) -> EventLoopFuture<User?>
    func updateUserInfo(user: User, userInfo: UserInfoProtocol) -> EventLoopFuture<User>
    func delete(id: UUID) -> EventLoopFuture<Void>
    func listMember(_ list: ShoppingList) -> EventLoopFuture<[User]>
}

struct DatabaseUserRepository: UserRepository, DatabaseRepository {
    func listMember(_ list: ShoppingList) -> EventLoopFuture<[User]> {
        return list.$members.get(on: database)
    }
    
    
    var database: Database
    
    func find(id: UUID?) -> EventLoopFuture<User?> {
        return User.find(id, on: database)
            
    }
    
    func find(email: String) -> EventLoopFuture<User?> {
        return User.query(on: database)
            .filter(\.$email == email)
            .first()
    }
    
    
    func delete(id: UUID) -> EventLoopFuture<Void> {
        return User.query(on: database)
            .filter(\.$id == id)
            .delete()
    }
    
    func create(_ user: User) -> EventLoopFuture<Void> {
        user.create(on: database)
    }
    
    func updateUserInfo(user: User, userInfo: UserInfoProtocol) -> EventLoopFuture<User> {
        if let avatarKey = userInfo.avatarImageKey {
            user.avatarImageKey = avatarKey
        }
        
        if let firstName = userInfo.firstName {
            user.firstName = firstName
        }
        
        if let secondName = userInfo.secondName {
            user.secondName = secondName
        }
        
        return  user.update(on: database)
            .map { user }
    }
}

extension DatabaseRepository {
    func `for`(_ req: Request) -> Self {
        return Self.init(database: req.db)
    }
}

extension Application.Repositories {
    var users: UserRepository {
        guard let storage = storage.makeUserRepository else {
            fatalError("UserRepository not configured, use: app.userRepository.use()")
        }
        
        return storage(app)
    }
    
    func use(_ make: @escaping (Application) -> (UserRepository)) {
        storage.makeUserRepository = make
    }
}
