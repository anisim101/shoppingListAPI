//
//  File.swift
//  
//
//  Created by Vladimir Anisimov on 20.12.2020.
//

import Vapor

extension ErrorMiddleware {

    internal struct ErrorResponse: Codable {
        var message: String
    }
    
    public static func `status`(environment: Environment) -> ErrorMiddleware {
        return .init { req, error in
            let response = Response()
            do {
                if let error = error as? ResponseProtocol {
                    let errorResponse = ErrorResponse(message: error.message)
                    response.body = try .init(data: JSONEncoder().encode(errorResponse))
                    response.status = error.status
                    response.headers.replaceOrAdd(name: .contentType, value: "application/json; charset=utf-8")
                    
                } else {
                    response.body = .init(string: "Oops: \(error)")
                    response.status = .badRequest
                    response.headers.replaceOrAdd(name: .contentType, value: "text/plain; charset=utf-8")
                }
               
            } catch {
                response.body = .init(string: "Oops: \(error)")
                response.status = .badRequest
                response.headers.replaceOrAdd(name: .contentType, value: "text/plain; charset=utf-8")
            }
            return response
        }

        
    }
}

