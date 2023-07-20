//
//  GetPostListRequest.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/07/06.
//

import Foundation

struct GetPostListRequest: Requestable {
    typealias ResultType = BoardInfo
    
    var uri: String = "/post/list/"
    var methods: HttpMethods = .get
    var auth: Bool = true
    var param: [String : Any]?
    var additionalInfo: String?
    
}
