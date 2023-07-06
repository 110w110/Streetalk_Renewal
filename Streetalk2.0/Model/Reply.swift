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
}

//struct Reply: Codable {
//    let id: Int?
//    let content: String?
//    let createdAt: Date?
//    let updatedAt: Date?
//    let postId: Int?
//    let userId: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case content
//        case createdAt
//        case updatedAt
//        case postId = "post_id"
//        case userId = "user_id"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        id = try values.decodeIfPresent(Int.self, forKey: .id)
//        content = try values.decodeIfPresent(String.self, forKey: .content)
//        createdAt = try values.decodeIfPresent(Date.self, forKey: .createdAt)
//        updatedAt = try values.decodeIfPresent(Date.self, forKey: .updatedAt)
//        postId = try values.decodeIfPresent(Int.self, forKey: .postId)
//        userId = try values.decodeIfPresent(Int.self, forKey: .userId)
//    }
//
//}
