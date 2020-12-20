//
//  File.swift
//  
//
//  Created by Vladimir Anisimov on 06.12.2020.
//


import Vapor


enum AuthenticationError: Error, ResponseProtocol {
    
    case emailAlreadyExists
    case invalidEmailOrPasswordFormat
    case invalidToken
    case invalidEmailOrPassword
    case notAuthorised
    
    var message: String {
        switch self {
        case .emailAlreadyExists:
            return "User with email already exists"
        case .invalidToken:
            return "Invalid token"
        case .invalidEmailOrPasswordFormat:
            return "Invalid email or password format"
        case .invalidEmailOrPassword:
            return "Invalid email or password"
        case .notAuthorised:
            return "Not authorised"
        }
    }
    
    var status: HTTPStatus {
        return .ok
    }
}

