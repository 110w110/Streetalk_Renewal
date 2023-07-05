//
//  JoinRequest.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/07/05.
//

import Foundation

struct JoinRequest: Requestable {
    typealias ResultType = String
    
    var uri: String = "/user"
    var methods: HttpMethods = .put
    var auth: Bool = true
    var param: [String : Any]?
    var additionalInfo: String?
    
}
