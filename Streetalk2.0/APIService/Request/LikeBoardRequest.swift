//
//  LikeBoardRequest.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/07/13.
//

import Foundation

struct LikeBoardRequest: Requestable {
    typealias ResultType = String
    
    var uri: String = "/boardLike"
    var methods: HttpMethods = .put
    var auth: Bool = true
    var param: [String : Any]?
    var additionalInfo: String?
    
}
