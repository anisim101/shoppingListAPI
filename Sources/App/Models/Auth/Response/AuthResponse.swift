//
//  File.swift
//  
//
//  Created by Vladimir Anisimov on 17.12.2020.
//

import Vapor

struct AuthResponse: Content {

    let user: User
    let token: String
    
    init(user: User, token: String) {
        self.user = user
        self.user.hashPassword = ""
        self.token = token
    }
    
}

struct SuccessResponse: Content {
    var message = "OK"
}

struct SuccessResponseModel<T: Content>: Content, ResponseProtocol {
    
    var message: String
    var data: T?
    
    var status: HTTPStatus {
        return .ok
    }
    
    init(message: String = "OK", data: T? = nil) {
        self.message = message
        self.data = data
    }
    
    
    init() {
        self.message = "OK"
        self.data = nil
    }
}
