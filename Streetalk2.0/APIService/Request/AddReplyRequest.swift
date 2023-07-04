//
//  AddReplyRequest.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/10.
//

import Foundation

struct AddReplyRequest: Requestable {
    typealias ResultType = Reply
    
    var uri: String = "/home"
    var methods: HttpMethods = .post
    var auth: Bool = false
    var param: [String : Any]?
    
}

// POST 로 보낼 정보
//let params = ["postId" : postId, "content" : content, "checkName" : checkName] as Dictionary
