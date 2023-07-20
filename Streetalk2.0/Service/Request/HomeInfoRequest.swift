//
//  HomeInfoRequest.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/07/10.
//

import Foundation

struct HomeInfoRequest: Requestable {
    typealias ResultType = HomeInfo
    
    var uri: String = "/home"
    var methods: HttpMethods = .get
    var auth: Bool = true
    var param: [String : Any]?
    var additionalInfo: String?
    
}
