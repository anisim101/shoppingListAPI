//
//  File.swift
//  
//
//  Created by Vladimir Anisimov on 22.12.2020.
//

import Vapor

enum ListError: Error, ResponseProtocol {
    
    case alreadyMember
    var message: String {
        switch self {
        
        case .alreadyMember:
            return "User already a list member"
        }
    }
    
    var status: HTTPStatus {
        return .ok
    }
}
