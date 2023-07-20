//
//  Requestable.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/10.
//

import Foundation
import UIKit

protocol Requestable {
    associatedtype ResultType: Codable
    var uri: String { get set }
    var methods: HttpMethods { get set }
    var auth: Bool { get set }
    var param: [String : Any]? { get set }
    var additionalInfo: String? { get set }
    
    func dataToObject(data: Data) -> Codable?
}

extension Requestable {
    var baseUrl: String { ServerData.url }
    var header: [String : String] { ["application/json" : "Content-Type"] }
    var headerForMulitipart: [String : String] { ["multipart/form-data; boundary=Streetalk" : "Content-Type"] }
    var credential: String? { UserDefaults.standard.string(forKey: "userToken") }
}

extension Requestable {
    func request(multipart: Bool = false, imageList: [UIImage?] = [], completion: @escaping (Result<ResultType, APIError>) -> Void) {
        var innerHeader: [String : String] = multipart ? self.headerForMulitipart : self.header
        
        if auth {
            guard let credential = credential else {
                print("Error: Invalid credential")
                return
            }
            
            innerHeader["Bearer " + credential] = "Authorization"
        }
        
        if multipart {
//            let imageList = imageList.count == 0 ? [UIImage(systemName: "star")] : imageList
            APIClient.shared.request(multipart: true, images: imageList, url: baseUrl + uri + (additionalInfo ?? ""), method: methods, header: innerHeader, param: param, completion: { result in
                switch result {
                case let .success(response):
                    guard let data = dataToObject(data: response) as? ResultType else { return }
                    completion(.success(data))
                case let .failure(error):
                    print(error)
                    completion(.failure(error))
                }
            })

        } else {
            APIClient.shared.request(url: baseUrl + uri + (additionalInfo ?? ""), method: methods, header: innerHeader, param: param) { result in
                switch result {
                case let .success(response):
                    guard let data = dataToObject(data: response) as? ResultType else { return }
                    completion(.success(data))
                case let .failure(error):
                    print(error)
                    completion(.failure(error))
                }
            }
        }
        
    }
    
    func dataToObject(data: Data) -> Codable? {
        do {
            if ResultType.self == String.self {
                let result = try JSONDecoder().decode(NetworkResponseWithoutData.self, from: data)
                return result.message
            } else {
                let result = try JSONDecoder().decode(NetworkResponse<ResultType>.self, from: data)
                return result.data
            }
        } catch {
            print("Error: Data decoding error")
            return nil
        }
    }
}

public enum HttpMethods: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case delete = "DELETE"
}
