//
//  File.swift
//  
//
//  Created by Vladimir Anisimov on 20.12.2020.
//

import Vapor

protocol ResponseProtocol {
    var message: String { get }
    var status: HTTPStatus { get }
}
