//
//  Location.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/08.
//

import Foundation

struct Address: Codable {
    let id: Int?
    let bigLocation: String?   // 시
    let middleLocation: String?    // 구

    enum CodingKeys: String, CodingKey {
        case id
        case bigLocation
        case middleLocation
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        bigLocation = try values.decodeIfPresent(String.self, forKey: .bigLocation)
        middleLocation = try values.decodeIfPresent(String.self, forKey: .middleLocation)
    }

}
