//
//  File.swift
//  
//
//  Created by Vladimir Anisimov on 06.12.2020.
//

import Foundation
import Vapor
import Fluent

class AuthController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.group("auth") { auth in
            auth.post("register", use: register)
            auth.post("login", use: login)
        }
    }
    
    
    private func register(_ req: Request) throws -> EventLoopFuture<AuthResponse> {
        try RegisterRequest.validate(content: req)
        let registerRequest = try req.content.decode(RegisterRequest.self)
        
        guard registerRequest.password == registerRequest.confirmPassword else {
            throw AuthenticationError.passwordsDontMatch
        }
        
        return req.password
            .async
            .hash(registerRequest.password)
            .flatMapThrowing { try User(from: registerRequest, hash: $0) }
            .flatMap { user in
                req.users
                    .create(user)
                    .flatMapErrorThrowing {
                        if let dbError = $0 as? DatabaseError, dbError.isConstraintFailure {
                            throw AuthenticationError.emailAlreadyExists
                        }
                        throw $0
                    }
                    .flatMapThrowing { _ in
                        let token = try user.getToken(req)
                        return AuthResponse(user: user, token: token)
                    }
            }
    }
    
    private func login(_ req: Request) throws -> EventLoopFuture<AuthResponse>{
        
        try LoginRequest.validate(content: req)
        let loginRequest = try req.content.decode(LoginRequest.self)
        
        return req.users
            .find(email: loginRequest.email)
            .unwrap(or: AuthenticationError.invalidEmailOrPassword)
            .flatMap { user -> EventLoopFuture<User> in
                return req.password
                    .async
                    .verify(loginRequest.password, created: user.hashPassword)
                    .guard({ $0 == true }, else: AuthenticationError.invalidEmailOrPassword)
                    .transform(to: user)
                
            }
            .flatMapThrowing {
                let token = try $0.getToken(req)
                return AuthResponse(user: $0, token: token)
            }
        
    }
}
