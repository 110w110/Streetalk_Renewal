//
//  RegisterRequest.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/07/04.
//

import Foundation

struct RegisterRequest: Requestable {
    typealias ResultType = RegisterRandNum
    
    var uri: String = "/user/auth"
    var methods: HttpMethods = .post
    var auth: Bool = false
    var param: [String : Any]? = nil
    
}
