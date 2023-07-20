//
//  SearchRequest.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/07/06.
//

import Foundation

struct SearchRequest: Requestable {
    typealias ResultType = [SearchPost]
    
    var uri: String = "/searchPost/"
    var methods: HttpMethods = .get
    var auth: Bool = true
    var param: [String : Any]?
    var additionalInfo: String?
    
}
