//
//  File.swift
//  
//
//  Created by Vladimir Anisimov on 19.12.2020.
//

import Vapor


struct NewShoppingListRequest: Content {
    let listName: String
    let listImageKey: String
}
