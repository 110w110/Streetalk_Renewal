//
//  Requestable.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/10.
//

import Foundation

protocol Requestable {
    var uri: String { get set }
    var methods: HttpMethods { get set }
    var auth: Bool { get set }
    var param: [String : Any]? { get set }
    func dataToObject(data: Data) -> Codable?
}

extension Requestable {
    var baseUrl: String { "http://43.200.53.77:8080" }
    var header: [String : String] { ["application/json" : "Content-Type"] }
    var credential: String? { UserDefaults.standard.string(forKey: "userToken") }
}

extension Requestable {
    func request(completion: @escaping (Result<Codable, APIError>) -> Void) {
        var innerHeader: [String : String] = self.header
        
        if auth {
            guard let credential = credential else {
                print("Error: Invalid credential")
                return
            }
            
            innerHeader["Bearer " + credential] = "Authorization"
        }
        
        APIClient.shared.request(url: baseUrl + uri, method: methods, header: innerHeader, param: param) { result in
            switch result {
            case let .success(data):
//                let json = String(decoding: data, as: UTF8.self)
                guard let object = dataToObject(data: data) else {
                    print("Error: object is nil")
                    return
                }
                completion(.success(object))
            case let .failure(error):
                print(error)
                completion(.failure(error))
            }
        }
    }
}

public enum HttpMethods: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case delete = "DELETE"
}

