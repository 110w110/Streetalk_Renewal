//
//  NoticeRequest.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/07/12.
//

import Foundation

struct NoticeRequest: Requestable {
    typealias ResultType = [Notice]
    
    var uri: String = "/user/notice"
    var methods: HttpMethods = .get
    var auth: Bool = true
    var param: [String : Any]?
    var additionalInfo: String?
    
}
