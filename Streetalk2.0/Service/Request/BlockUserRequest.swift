//
//  BlockUserRequest.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/08/01.
//

import Foundation
//GET /user/block/{blockedUserId}
//DELETE /user/block/{blockedUserId}

struct BlockRequest: Requestable {
    typealias ResultType = String
    
    var uri: String = "/user/block/"
    var methods: HttpMethods = .get
    var auth: Bool = true
    var param: [String : Any]?
    var additionalInfo: String?
    
}
