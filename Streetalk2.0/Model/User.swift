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
    let phoneNum: Int?
    let createdDate: Date?
    let updatedDate: Date?
    let location: Address?
    let industry: Industry?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case phoneNum
        case createdDate
        case updatedDate
        case location
        case industry
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        phoneNum = try values.decodeIfPresent(Int.self, forKey: .phoneNum)
        createdDate = try values.decodeIfPresent(Date.self, forKey: .createdDate)
        updatedDate = try values.decodeIfPresent(Date.self, forKey: .updatedDate)
        location = try values.decodeIfPresent(Address.self, forKey: .location)
        industry = try values.decodeIfPresent(Industry.self, forKey: .industry)
    }

}
