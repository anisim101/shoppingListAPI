//
//  File.swift
//  
//
//  Created by Vladimir Anisimov on 20.12.2020.
//

import Vapor

enum RequestError: Error, ResponseProtocol {
    
    case invalidJson, wrongRequest
    
    
    var status: HTTPStatus {
        return .badRequest
    }
    
    var message: String {
        switch self {
        
        case .invalidJson:
            return "Wrong request"
        case .wrongRequest:
            return "Wrong request"
        }
    }
    
}
