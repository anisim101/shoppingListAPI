//
//  File.swift
//  
//
//  Created by Vladimir Anisimov on 20.12.2020.
//

import Vapor

enum InternalError: Int, Error, ResponseProtocol {

    case internalDatabaseError = 0
    case internalError
    
    var status: HTTPStatus {
        return .internalServerError
    }
    
    var message: String {
        return "Internal Error (\(self.rawValue))"
    }
    
}
