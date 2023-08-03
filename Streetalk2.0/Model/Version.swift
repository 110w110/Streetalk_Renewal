//
//  Version.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/08/03.
//

import Foundation

struct Version: Codable {
    let minimum: String?
    let latest: String?

    enum CodingKeys: String, CodingKey {
        case minimum
        case latest
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        minimum = try values.decodeIfPresent(String.self, forKey: .minimum)
        latest = try values.decodeIfPresent(String.self, forKey: .latest)
    }

}
