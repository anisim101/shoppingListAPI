//
//  File.swift
//  
//
//  Created by Vladimir Anisimov on 06.12.2020.
//

import Vapor
import JWT

struct TestPayload: JWTPayload {
   
    enum CodingKeys: String, CodingKey {
        
        case expiration = "exp"
        case user = "user"
    }

    var expiration: ExpirationClaim
    var user: User

   
    func verify(using signer: JWTSigner) throws {
        try self.expiration.verifyNotExpired()
    }
}
