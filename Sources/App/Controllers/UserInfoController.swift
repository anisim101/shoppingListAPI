//
//  File.swift
//  
//
//  Created by Vladimir Anisimov on 17.12.2020.
//

import Vapor

class UserInfoController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.group("user", configure: {
            $0.post("update", use: updateUserInfo)
        })
    }
    
    private func updateUserInfo(_ req: Request) throws -> EventLoopFuture<SuccessResponseModel<User>> {
        guard let request = try? req.content.decode(UpdateUserInfoRequest.self) else {
            throw RequestError.invalidJson
        }
        
        return try User.auth(req: req)
            .hop(to: req.eventLoop)
            .flatMap {
                req.users
                    .updateUserInfo(user: $0, userInfo: request)
                    .map {
                        $0.hashPassword = ""
                        return SuccessResponseModel(data: $0)
                    }
            }
    }
}
