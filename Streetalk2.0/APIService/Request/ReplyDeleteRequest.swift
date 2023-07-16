//
//  ReplyDeleteRequest.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/07/16.
//

import Foundation

struct ReplyDeleteRequest: Requestable {
    typealias ResultType = String
    
    var uri: String = "/reply/"
    var methods: HttpMethods = .delete
    var auth: Bool = true
    var param: [String : Any]?
    var additionalInfo: String?
    
}
