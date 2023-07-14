//
//  PostPostRequest.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/07/11.
//

import Foundation

struct PostPostRequest: Requestable {
    typealias ResultType = String
    
    var uri: String = "/post"
    var methods: HttpMethods = .post
    var auth: Bool = true
    var param: [String : Any]?
    var additionalInfo: String?
    
}
