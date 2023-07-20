//
//  RefreshTokenRequest.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/07/18.
//

import Foundation

struct RefreshToken: Requestable {
    typealias ResultType = Token
    
    var uri: String = "/user/refreshToken"
    var methods: HttpMethods = .put
    var auth: Bool = true
    var param: [String : Any]?
    var additionalInfo: String?
    
}
