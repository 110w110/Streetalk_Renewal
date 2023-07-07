//
//  boardList.Requestswift.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/07/07.
//

import Foundation

struct boardListRequest: Requestable {
    typealias ResultType = [Board]
    
    var uri: String = "/board/list"
    var methods: HttpMethods = .get
    var auth: Bool = true
    var param: [String : Any]?
    var additionalInfo: String?
    
}
