//
//  BoardInfo.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/07/19.
//

import Foundation

struct BoardInfo: Codable {
    let like : Bool?
    let postList : [PostList]?

    enum CodingKeys: String, CodingKey {
        case like = "boardLike"
        case postList = "postListDto"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        like = try values.decodeIfPresent(Bool.self, forKey: .like)
        postList = try values.decodeIfPresent([PostList].self, forKey: .postList)
    }

}
