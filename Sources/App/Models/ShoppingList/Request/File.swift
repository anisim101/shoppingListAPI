//
//  File.swift
//  
//
//  Created by Vladimir Anisimov on 21.12.2020.
//

import Vapor

struct AddMemberToListRequest: Content {
    var memberId:UUID
    var listId: UUID
    
}
