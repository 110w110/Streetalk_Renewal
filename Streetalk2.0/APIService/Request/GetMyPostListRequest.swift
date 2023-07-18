//
//  GetMyPostListRequest.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/07/18.
//

import Foundation

struct GetMyPostListRequest: Requestable {
    typealias ResultType = [SearchPost]
    
    var uri: String = "/user/post"
    var methods: HttpMethods = .get
    var auth: Bool = true
    var param: [String : Any]?
    var additionalInfo: String?
    
}
