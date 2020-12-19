//
//  File.swift
//  
//
//  Created by Vladimir Anisimov on 06.12.2020.
//

import Vapor



func migrations(_ app: Application) throws {
    app.migrations.add(CreateUsers())
    app.migrations.add(CreateShoppingLists())
    app.migrations.add(CreateUserLists())
}
