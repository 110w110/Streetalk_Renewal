//
//  SearchPost.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/07/06.
//

import Foundation

struct SearchPost: Codable {
    let createdDate : String?
    let modifiedDate : String?
    let id : Int?
    let title : String?
    let content : String?
    let writer: String?
    let postLike : Bool?
    let postScrap : Bool?
    let likeCount : Int?
    let scrapCount : Int?
    let replyCount : Int?
    let images : [SearchImage]?
    let replyList : [SearchReply]?

    enum CodingKeys: String, CodingKey {
        case createdDate = "createTime"
        case modifiedDate
        case id = "postId"
        case title
        case content
        case writer
        case postLike
        case postScrap
        case likeCount
        case scrapCount
        case replyCount
        case images
        case replyList
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        createdDate = try values.decodeIfPresent(String.self, forKey: .createdDate)
        modifiedDate = try values.decodeIfPresent(String.self, forKey: .modifiedDate)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        content = try values.decodeIfPresent(String.self, forKey: .content)
        writer = try values.decodeIfPresent(String.self, forKey: .writer)
        postLike = try values.decodeIfPresent(Bool.self, forKey: .postLike)
        postScrap = try values.decodeIfPresent(Bool.self, forKey: .postScrap)
        likeCount = try values.decodeIfPresent(Int.self, forKey: .likeCount)
        scrapCount = try values.decodeIfPresent(Int.self, forKey: .scrapCount)
        replyCount = try values.decodeIfPresent(Int.self, forKey: .replyCount)
        images = try values.decodeIfPresent([SearchImage].self, forKey: .images)
        replyList = try values.decodeIfPresent([SearchReply].self, forKey: .replyList)
    }

}

struct SearchReply : Codable {
    let createdDate : String?
    let modifiedDate : Date?
    let id : Int?
    let nickName : String?
    let location : String?
    let content : String?
}

struct SearchImage : Codable {
    let createdDate : String?
    let modifiedDate : String?
    let id : Int?
    let name : String?
}
