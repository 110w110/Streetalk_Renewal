//
//  RegisterRandNum.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/07/04.
//

import Foundation

struct RegisterRandNum: Codable {
    let randomNum: String?

    enum CodingKeys: String, CodingKey {
        case randomNum
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        randomNum = try values.decodeIfPresent(String.self, forKey: .randomNum)
    }

}
