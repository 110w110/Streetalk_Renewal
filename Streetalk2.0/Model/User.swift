//
//  User.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/08.
//

import Foundation

struct User: Codable {
    let id: Int?
    let name: String?
    let location: Address?
    let industry: Industry?

    enum CodingKeys: String, CodingKey {
        case id = "userId"
        case name = "userName"
        case location
        case industry
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        location = try values.decodeIfPresent(Address.self, forKey: .location)
        industry = try values.decodeIfPresent(Industry.self, forKey: .industry)
    }

}
