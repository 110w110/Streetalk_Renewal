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
    var headerForMulitipart: [String : String] { ["multipart/form-data; boundary=\(UUID().uuidString)" : "Content-Type"] }
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
        
//        if multipart {
//            let boundary = UUID().uuidString
//            let imageList = imageList.count == 0 ? [UIImage(systemName: "star")] : imageList
//
//            guard let bodyData = createBody(parameters: param, boundary: boundary, imageList: imageList, mimeType: "image/png", filename: "Image.png") else { return }
//
//            APIClient.shared.request(url: baseUrl + uri + (additionalInfo ?? ""), method: methods, header: innerHeader, param: param, completion: { result in
//                switch result {
//                case let .success(response):
//                    guard let data = dataToObject(data: response) as? ResultType else { return }
//                    completion(.success(data))
//                case let .failure(error):
//                    print(error)
//                    completion(.failure(error))
//                }
//            })
//
//        } else {
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
//        }
        
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
//
//    private func generateBoundaryString() -> String {
//        return "Boundary-\(UUID().uuidString)"
//    }
//
//
    
    private func createBody(parameters: [String: Any]?,
                                boundary: String,
                                imageList: [UIImage?],
                                mimeType: String,
                                filename: String) -> Data? {
//        var body = Data()
//        let imgDataKey = "multipartFiles"
//        let boundaryPrefix = "--\(boundary)\r\n"
//
//        if let parameters = parameters {
//            for (key, value) in parameters {
//                body.append(boundaryPrefix.data(using: .utf8)!)
//                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
//                body.append("\(value)\r\n".data(using: .utf8)!)
//            }
//        }
//
//        for data in dataList {
//            body.append(boundaryPrefix.data(using: .utf8)!)
//            body.append("Content-Disposition: form-data; name=\"\(imgDataKey)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
//            body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
//            body.append(data)
//            body.append("\r\n".data(using: .utf8)!)
//            body.append("--".appending(boundary.appending("--\r\n")).data(using: .utf8)!)
//        }
//
//        return body as Data
        
        guard let image = imageList[0] else { return nil }
        let filename = "test.png"
        let boundary = UUID().uuidString
        let fields: [String : Any] = ["boardId" : 2, "title" : "title test 5", "content" : "content test", "checkName" : false]
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        var urlRequest = URLRequest(url: URL(string: "http://3.34.54.180:8080/post")!)
        urlRequest.httpMethod = "POST"

        let token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIwMTAwMDAwMDAwMCIsInJvbGUiOiJVU0VSIiwibmFtZSI6IjAxMDAwMDAwMDAwIiwiZXhwIjoxNjkwMzU3ODMzLCJpYXQiOjE2ODkwNjE4MzN9.iVqlmkb3AAWb5sbaAHypNvLjkbojmaJoiFHuz6zs5m4"
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")

        var data = Data()

        for field in fields {
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"\(field.key)\"\r\n\r\n".data(using: .utf8)!)
            data.append("\(field.value)".data(using: .utf8)!)
        }
        
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"multipartFiles\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(image.pngData()!)

        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        print(String(decoding: data, as: UTF8.self))
        
//        var data = Data()
//
//        guard let fields = parameters else { return nil }
//        for field in fields {
//            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
//            data.append("Content-Disposition: form-data; name=\"\(field.key)\"\r\n\r\n".data(using: .utf8)!)
//            data.append("\(field.value)".data(using: .utf8)!)
//        }
//
//        for image in imageList {
//            guard let image = image else { return nil }
//            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
//            data.append("Content-Disposition: form-data; name=\"multipartFiles\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
//            data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
//            data.append(image.pngData()!)
//        }
//
//        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
//
//        print(String(decoding: data, as: UTF8.self))
        
        return data
    }
    
    func upload(images: [UIImage?], completion: @escaping (Result<ResultType, APIError>) -> Void) {
        var innerHeader: [String : String] = self.headerForMulitipart
        
        if auth {
            guard let credential = credential else {
                print("Error: Invalid credential")
                return
            }
            
            innerHeader["Bearer " + credential] = "Authorization"
        }
        
        APIClient.shared.request(images: images, url: baseUrl + uri + (additionalInfo ?? ""), method: methods, header: innerHeader, param: param, completion: { result in
            switch result {
            case let .success(response):
                guard let data = dataToObject(data: response) as? ResultType else { return }
                completion(.success(data))
            case let .failure(error):
                print(error)
                completion(.failure(error))
            }
        })
    }
}

public enum HttpMethods: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case delete = "DELETE"
}
