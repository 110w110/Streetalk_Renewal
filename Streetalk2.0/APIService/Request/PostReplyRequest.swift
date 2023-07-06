//
//  PostReply.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/07/06.
//

import Foundation

struct PostReplyRequest: Requestable {
    typealias ResultType = String
    
    var uri: String = "/reply"
    var methods: HttpMethods = .post
    var auth: Bool = true
    var param: [String : Any]?
    var additionalInfo: String?
    
}
