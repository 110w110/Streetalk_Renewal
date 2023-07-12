//
//  Notice.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/07/12.
//

import Foundation

struct Notice: Codable {
    let createdDate: String?
    let modifiedDate: String?
    let id: Int?
    let title: String?
    let content: String?

    enum CodingKeys: String, CodingKey {
        case createdDate
        case modifiedDate
        case id
        case title
        case content
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        createdDate = try values.decodeIfPresent(String.self, forKey: .createdDate)
        modifiedDate = try values.decodeIfPresent(String.self, forKey: .modifiedDate)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        content = try values.decodeIfPresent(String.self, forKey: .content)
    }

}

