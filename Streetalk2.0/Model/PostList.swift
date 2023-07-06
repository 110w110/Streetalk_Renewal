//
//  PostList.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/07/06.
//

import Foundation

struct PostList: Codable {
    let postId : Int?
    let title : String?
    let content : String?
    let location : String?
    let writer : String?
    let lastTime : Int?
    let likeCount : Int?
    let scrapCount : Int?
    let replyCount : Int?

    enum CodingKeys: String, CodingKey {
        case postId
        case title
        case content
        case location
        case writer
        case lastTime
        case likeCount
        case scrapCount
        case replyCount
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        postId = try values.decodeIfPresent(Int.self, forKey: .postId)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        content = try values.decodeIfPresent(String.self, forKey: .content)
        location = try values.decodeIfPresent(String.self, forKey: .location)
        writer = try values.decodeIfPresent(String.self, forKey: .writer)
        lastTime = try values.decodeIfPresent(Int.self, forKey: .lastTime)
        likeCount = try values.decodeIfPresent(Int.self, forKey: .likeCount)
        scrapCount = try values.decodeIfPresent(Int.self, forKey: .scrapCount)
        replyCount = try values.decodeIfPresent(Int.self, forKey: .replyCount)
    }

}
