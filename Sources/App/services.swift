//
//  File.swift
//  
//
//  Created by Vladimir Anisimov on 06.12.2020.
//

import Vapor

func services(_ app: Application) throws {
    app.repositories.use(.database)
}
