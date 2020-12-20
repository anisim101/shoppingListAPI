//
//  File.swift
//  
//
//  Created by Vladimir Anisimov on 20.12.2020.
//

import Vapor

enum RequestError: Error, ResponseProtocol {
    
    case invalidJson
    var code: Int {
        switch self {
        case .invalidJson:
            return 1
        }
    }
    
    var status: HTTPStatus {
        return .badRequest
    }
    
    var message: String {
        switch self {
        
        case .invalidJson:
            return "Wrong request"
        }
    }
    
}
