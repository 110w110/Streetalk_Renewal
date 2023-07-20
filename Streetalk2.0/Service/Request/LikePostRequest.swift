//
//  LikePostRequest.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/07/12.
//

import Foundation

struct LikePostRequest: Requestable {
    typealias ResultType = String
    
    var uri: String = "/postLike"
    var methods: HttpMethods = .put
    var auth: Bool = true
    var param: [String : Any]?
    var additionalInfo: String?
    
}
