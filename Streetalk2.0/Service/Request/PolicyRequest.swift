//
//  policyRequest.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/07/07.
//

import Foundation

struct PolicyRequest: Requestable {
    typealias ResultType = Policy
    
    var uri: String = "/user/policy"
    var methods: HttpMethods = .get
    var auth: Bool = true
    var param: [String : Any]?
    var additionalInfo: String?
    
}
