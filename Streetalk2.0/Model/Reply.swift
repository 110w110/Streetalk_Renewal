//
//  Reply.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/08.
//

import Foundation

struct Reply : Codable {
    let replyId : Int?
    let replyWriterId : Int?
    let replyWriterName : String?
    let location : String?
    let content : String?
    let lastTime : Int?
    let hasAuthority : Bool?
    let isPrivate : Bool?
}
