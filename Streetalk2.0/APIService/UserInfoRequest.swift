//
//  UserInfoRequest.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/10.
//

import Foundation

struct UserInfoRequest: Requestable {
    var uri: String = "/user"
    var methods: HttpMethods = .get
    var auth: Bool = true
    var param: [String : Any]? = nil
    
    func dataToObject(data: Data) -> Codable? {
        do {
            let result = try JSONDecoder().decode(User.self, from: data)
            return result
        } catch {
            print("Error: Data decoding error")
            return nil
        }
    }
}
