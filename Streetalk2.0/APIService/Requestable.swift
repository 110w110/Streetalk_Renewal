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
}

extension Requestable {
    var baseUrl: String { "http://43.200.53.77:8080" }
    var header: [String : String] { ["application/json" : "Content-Type"] }
    var credential: String? { UserDefaults.standard.string(forKey: "userToken") }
}

extension Requestable {
    func request() {
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
                print(data)
            case let .failure(error):
                print(error)
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

