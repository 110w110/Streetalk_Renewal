//
//  Post.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/08.
//

import Foundation

struct Post: Codable {
    let boardName : String?
    let postWriterName : String?
    let postWriterId : Int?
    let location : String?
    let industry : String?
    let title : String?
    let content : String?
    let likeCount : Int?
    let scrapCount : Int?
    let replyCount : Int?
    let lastTime : Int?
    let postLike : Bool?
    let postScrap : Bool?
    let replyList : [Reply]?
    let hasAuthority : Bool?
    let isPrivate : Bool?
    let images : [String]?

    enum CodingKeys: String, CodingKey {
        case boardName
        case postWriterName
        case postWriterId
        case location
        case industry
        case title
        case content
        case likeCount
        case scrapCount
        case replyCount
        case lastTime
        case postLike
        case postScrap
        case replyList
        case hasAuthority
        case isPrivate
        case images
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        boardName = try values.decodeIfPresent(String.self, forKey: .boardName)
        postWriterName = try values.decodeIfPresent(String.self, forKey: .postWriterName)
        postWriterId = try values.decodeIfPresent(Int.self, forKey: .postWriterId)
        location = try values.decodeIfPresent(String.self, forKey: .location)
        industry = try values.decodeIfPresent(String.self, forKey: .industry)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        content = try values.decodeIfPresent(String.self, forKey: .content)
        likeCount = try values.decodeIfPresent(Int.self, forKey: .likeCount)
        scrapCount = try values.decodeIfPresent(Int.self, forKey: .scrapCount)
        replyCount = try values.decodeIfPresent(Int.self, forKey: .replyCount)
        lastTime = try values.decodeIfPresent(Int.self, forKey: .lastTime)
        postLike = try values.decodeIfPresent(Bool.self, forKey: .postLike)
        postScrap = try values.decodeIfPresent(Bool.self, forKey: .postScrap)
        replyList = try values.decodeIfPresent([Reply].self, forKey: .replyList)
        hasAuthority = try values.decodeIfPresent(Bool.self, forKey: .hasAuthority)
        isPrivate = try values.decodeIfPresent(Bool.self, forKey: .isPrivate)
        images = try values.decodeIfPresent([String].self, forKey: .images)
    }

}

