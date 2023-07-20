//
//  ReportReplyRequest.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/07/13.
//

import Foundation

struct ReportReplyRequest: Requestable {
    typealias ResultType = Bool
    
    var uri: String = "/lockReply"
    var methods: HttpMethods = .post
    var auth: Bool = true
    var param: [String : Any]?
    var additionalInfo: String?
    
}
