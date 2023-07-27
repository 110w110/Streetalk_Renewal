//
//  Notice.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/07/12.
//

import Foundation

struct Notice: Codable {
    let id: Int?
    let createDate: String?
    let title: String?
    let content: String?

    enum CodingKeys: String, CodingKey {
        case id
        case createDate
        case title
        case content
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        createDate = try values.decodeIfPresent(String.self, forKey: .createDate)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        content = try values.decodeIfPresent(String.self, forKey: .content)
    }

}

