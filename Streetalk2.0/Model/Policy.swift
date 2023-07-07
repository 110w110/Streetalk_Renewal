//
//  Policy.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/07/07.
//

import Foundation

struct Policy: Codable {
    let id: Int?
    let termsOfUse: String?
    let privatePolicy: String?

    enum CodingKeys: String, CodingKey {
        case id
        case termsOfUse
        case privatePolicy
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        termsOfUse = try values.decodeIfPresent(String.self, forKey: .termsOfUse)
        privatePolicy = try values.decodeIfPresent(String.self, forKey: .privatePolicy)
    }

}

