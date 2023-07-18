//
//  Token.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/07/18.
//

import Foundation

struct Token: Codable {
    let token: String?

    enum CodingKeys: String, CodingKey {
        case token
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        token = try values.decodeIfPresent(String.self, forKey: .token)
    }

}
