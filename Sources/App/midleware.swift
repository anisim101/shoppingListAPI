//
//  File.swift
//  
//
//  Created by Vladimir Anisimov on 20.12.2020.
//

import Vapor

func middleware(_ app: Application) throws {
    let error = ErrorMiddleware.status(environment: app.environment)

    app.middleware.use(error)
    
}

