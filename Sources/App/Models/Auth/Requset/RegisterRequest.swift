//
//  File.swift
//  
//
//  Created by Vladimir Anisimov on 06.12.2020.
//

import Vapor


struct RegisterRequest: Content {
    let email: String
    let password: String
}

extension RegisterRequest: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: .count(8...))
    }
    
}

extension User {
    convenience init(from register: RegisterRequest, hash: String) throws {
        self.init(email: register.email, hashPassword: hash)
    }
}
