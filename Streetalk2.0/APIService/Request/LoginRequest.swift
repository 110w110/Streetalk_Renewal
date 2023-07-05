//
//  LoginRequest.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/07/05.
//

import Foundation

struct LoginRequest: Requestable {
    typealias ResultType = Login
    
    var uri: String = "/user/login"
    var methods: HttpMethods = .post
    var auth: Bool = false
    var param: [String : Any]?
    var additionalInfo: String?
    
}
