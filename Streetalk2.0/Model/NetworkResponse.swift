//
//  NetworkResponse.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/08.
//

import Foundation

struct NetworkResponse<T: Codable>: Decodable {
    let status: Int?
    let success: Bool?
    let message: String?
    let data: T
    
    enum CodingKeys: String, CodingKey {
        case status
        case success
        case message
        case data
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decode(T.self, forKey: .data)
    }
}

struct NetworkResponseWithoutData: Decodable {
    let status: Int?
    let success: Bool?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case status
        case success
        case message
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }
}
