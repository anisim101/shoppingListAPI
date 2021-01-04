//
//  File.swift
//  
//
//  Created by Vladimir Anisimov on 29.12.2020.
//

import Vapor
import ImperialGoogle

extension Google {
    struct GoogleUserInfo: Content {
        let email: String
        let name: String
    }
    
    static var googleAPIURL: URI {
        return URI(string: "https://www.googleapis.com/oauth2/v1/userinfo?alt=json")
    }
    static func getUser(on request: Request) throws -> EventLoopFuture<GoogleUserInfo> {
        var headers = HTTPHeaders()
        headers.bearerAuthorization =
            try BearerAuthorization(token: request.accessToken())
        
        let response = request
            .client
            .get(Google.googleAPIURL, headers: headers)
            .guard({ $0.status == .ok }, else: RequestError.wrongRequest)
        return response.map { response in
            let info = try? response.content.decode(GoogleUserInfo.self)
            return info
            
        }
        .unwrap(orError: InternalError.internalError)
    }
}
