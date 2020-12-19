//
//  File.swift
//  
//
//  Created by Vladimir Anisimov on 06.12.2020.
//

import Vapor

protocol AppError: AbortError, DebuggableError {}
