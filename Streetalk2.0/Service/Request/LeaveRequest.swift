//
//  LeaveRequest.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/07/19.
//

import Foundation

struct LeaveReqeust: Requestable {
    typealias ResultType = String
    
    var uri: String = "/user"
    var methods: HttpMethods = .delete
    var auth: Bool = true
    var param: [String : Any]?
    var additionalInfo: String?
    
}
