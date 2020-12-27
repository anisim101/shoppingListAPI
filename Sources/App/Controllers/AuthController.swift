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
            auth.post("apple", use: SWA)
        }
    }
    
    private func register(_ req: Request) throws -> EventLoopFuture<SuccessResponseModel<AuthResponse>> {
        do {
            try RegisterRequest.validate(content: req)
        } catch {
            throw AuthenticationError.invalidEmailOrPasswordFormat
        }
        
        guard let registerRequest = try? req.content.decode(RegisterRequest.self) else {
            throw RequestError.invalidJson
        }
        
        return req.password
            .async
            .hash(registerRequest.password)
            .flatMapThrowing {
                try User(from: registerRequest, hash: $0) }
            .flatMap { user in
                req.users
                    .create(user)
                    .flatMapErrorThrowing {
                        if let dbError = $0 as? DatabaseError, dbError.isConstraintFailure {
                            throw AuthenticationError.emailAlreadyExists
                        }
                        throw InternalError.internalDatabaseError
                    }
                    .flatMapThrowing { _ in
                        let token = try user.getToken(req)
                        
                        return SuccessResponseModel(data: AuthResponse(user: user, token: token))
                    }
            }
    }
    
    private func login(_ req: Request) throws -> EventLoopFuture<SuccessResponseModel<AuthResponse>> {
        
        do {
            try LoginRequest.validate(content: req)
        } catch {
            throw AuthenticationError.invalidEmailOrPassword
        }
        
        guard let loginRequest = try? req.content.decode(LoginRequest.self) else {
            throw RequestError.invalidJson
        }
        
        return req.users
            .find(email: loginRequest.email)
            .unwrap(or: AuthenticationError.invalidEmailOrPassword )
            .flatMap { user -> EventLoopFuture<User> in
                return req.password
                    .async
                    .verify(loginRequest.password, created: user.hashPassword ?? "")
                    .guard({ $0 == true }, else: AuthenticationError.invalidEmailOrPassword)
                    .transform(to: user)
                
            }
            .flatMapThrowing {
                let token = try $0.getToken(req)
                return SuccessResponseModel(data: AuthResponse(user: $0, token: token))
            }
        
    }
    
    private func SWA(_ req: Request) throws -> EventLoopFuture<SuccessResponseModel<AuthResponse>> {
        
        struct SIWARequestBody: Content {
            let firstName: String?
            let lastName: String?
            let appleIdentityToken: String
        }
        
        guard let userBody = try? req.content.decode(SIWARequestBody.self) else { throw RequestError.wrongRequest }
        
        
        let appleIdentityToken = req.jwt.apple.verify(userBody.appleIdentityToken,
                                                      applicationIdentifier: "com.tegoo.app")
        
        return  appleIdentityToken.flatMap { appleIdentityToken in
            let email = appleIdentityToken.email!
            let dbUser =  req.users.find(email: email)
            
            return dbUser
                .flatMap { user -> EventLoopFuture<User> in
                    if user != nil  {
                        return dbUser.unwrap(orError: InternalError.internalError)
                        
                    } else {
                        let newUser = User(email: email,
                                           firstName: userBody.firstName,
                                           secondName: userBody.lastName)
                        return  req.users.create(newUser).transform(to: newUser)
                        
                    }
                }
                .flatMapThrowing { user in
                    let token = try user.getToken(req)
                    return SuccessResponseModel(data: AuthResponse(user: user, token: token))
                }
        }
        
    }
}
