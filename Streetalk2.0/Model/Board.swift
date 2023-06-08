//
//  Board.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/08.
//

import Foundation

struct Board: Codable {
    let id: Int?
    let boardName: String?   // 게시판 이름
    let category: String?   // 카테고리

    enum CodingKeys: String, CodingKey {
        case id
        case boardName
        case category
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        boardName = try values.decodeIfPresent(String.self, forKey: .boardName)
        category = try values.decodeIfPresent(String.self, forKey: .category)
    }

}
