//
//  File.swift
//  
//
//  Created by Vladimir Anisimov on 17.12.2020.
//

import Vapor

protocol UserInfoProtocol {
    var firstName: String? { get set }
    var secondName: String? { get set }
    var avatarImageKey: String? { get set }
}

struct UpdateUserInfoRequest: UserInfoProtocol, Content {
    var firstName: String?
    var secondName: String?
    var avatarImageKey: String?    
}
