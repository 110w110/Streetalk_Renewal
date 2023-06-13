//
//  AddReplyRequest.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/10.
//

import Foundation

struct AddReplyRequest: Requestable {
    var uri: String = "/home"
    var methods: HttpMethods = .post
    var auth: Bool = false
    var param: [String : Any]?
    
    var response: Responsable
    
    // dto 함수 각 request 마다 만드는 것이 좋을지..?
    // 함수 시그니처를 프로토콜에 추가하는게 좋을 것 같은데
    // response를 어디서 소유해야할지..?
//    func dataToObject(_ data: Data) -> Codable {
//
//    }
}

// POST 로 보낼 정보
//let params = ["postId" : postId, "content" : content, "checkName" : checkName] as Dictionary
