//
//  File.swift
//  
//
//  Created by Vladimir Anisimov on 06.12.2020.
//

import Vapor

extension Request {
    var users: UserRepository { application.repositories.users.for(self)}
    var shoppingLists: ShoppingListRepository { application.repositories.shoppingLists.for(self)}
}

