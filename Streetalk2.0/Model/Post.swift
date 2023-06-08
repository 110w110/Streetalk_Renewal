//
//  Post.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/08.
//

import Foundation

struct Post: Codable {
    let id: Int?
    let title: String?
    let content: String?
    let createdAt: Date?
    let updatedAt: Date?
    let likeCount: Int?
    let anonymous: Bool?
    let boardId: Int?
    let userId: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case content
        case createdAt
        case updatedAt
        case likeCount
        case anonymous
        case boardId = "board_id"
        case userId = "user_id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        content = try values.decodeIfPresent(String.self, forKey: .content)
        createdAt = try values.decodeIfPresent(Date.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(Date.self, forKey: .updatedAt)
        likeCount = try values.decodeIfPresent(Int.self, forKey: .likeCount)
        anonymous = try values.decodeIfPresent(Bool.self, forKey: .anonymous)
        boardId = try values.decodeIfPresent(Int.self, forKey: .boardId)
        userId = try values.decodeIfPresent(Int.self, forKey: .userId)
    }

}
