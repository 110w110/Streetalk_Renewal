//
//  GetMyReply.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/07/19.
//

import Foundation

struct GetMyReplyListRequest: Requestable {
    typealias ResultType = [SearchPost]
    
    var uri: String = "/user/postMyReply"
    var methods: HttpMethods = .get
    var auth: Bool = true
    var param: [String : Any]?
    var additionalInfo: String?
    
}
