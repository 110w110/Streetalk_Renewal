//
//  GetProfileRequest.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/07/20.
//

import Foundation

struct GetProfileRequest: Requestable {
    typealias ResultType = Login
    
    var uri: String = "/user/profile"
    var methods: HttpMethods = .get
    var auth: Bool = true
    var param: [String : Any]?
    var additionalInfo: String?
    
}
