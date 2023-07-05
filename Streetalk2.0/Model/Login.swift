//
//  Login.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/07/05.
//

import Foundation

struct Login: Codable {
    let token : String?
    let userName : String?
    let location : String?
    let industry : String?
    let currentCity : String?
    let nearCities : [Cities]?

    enum CodingKeys: String, CodingKey {
        case token
        case userName
        case location
        case industry
        case currentCity
        case nearCities
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        token = try values.decodeIfPresent(String.self, forKey: .token)
        userName = try values.decodeIfPresent(String.self, forKey: .userName)
        location = try values.decodeIfPresent(String.self, forKey: .location)
        industry = try values.decodeIfPresent(String.self, forKey: .industry)
        currentCity = try values.decodeIfPresent(String.self, forKey: .currentCity)
        nearCities = try values.decodeIfPresent([Cities].self, forKey: .nearCities)
    }

}

struct Cities : Codable {
    let fullName : String?
    let id : Int?
}
