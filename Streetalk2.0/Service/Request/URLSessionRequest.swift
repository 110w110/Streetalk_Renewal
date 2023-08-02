//
//  AnyRequest.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/08/02.
//

import Foundation

struct URLSessionRequest<T: Codable>: Requestable {
    typealias ResultType = T
    
    var uri: String = "/home"
    var methods: HttpMethods = .get
    var auth: Bool = true
    var param: [String : Any]?
    var additionalInfo: String?
    
}
