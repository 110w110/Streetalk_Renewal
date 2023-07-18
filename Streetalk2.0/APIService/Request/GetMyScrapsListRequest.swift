//
//  GetMyScrapsListRequest.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/07/18.
//

import Foundation

struct GetMyScrapsListRequest: Requestable {
    typealias ResultType = [SearchPost]
    
    var uri: String = "/user/postScraps"
    var methods: HttpMethods = .get
    var auth: Bool = true
    var param: [String : Any]?
    var additionalInfo: String?
    
}
