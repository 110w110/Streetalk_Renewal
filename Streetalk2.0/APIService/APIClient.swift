//
//  APIService.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/05/31.
//

import Foundation

final class APIClient {
    static let shared = APIClient()
    private init() {}
    
    private let timeoutInterval = 10.0
    
    func request(url: String, method: HttpMethods, header: [String : String],  param: [String : Any]?, completion: @escaping (Result<Data, APIError>) -> Void) {
        guard let url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: url) else {
            print("Error: cannot create URL")
//            throw APIError.invalidUrl
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = timeoutInterval
        
        if let param = param {
            request.httpBody = try? JSONSerialization.data(withJSONObject: param, options: [])
        }
        
        for item in header {
            request.setValue(item.key, forHTTPHeaderField: item.value)
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                print("Error: request failed \(error)")
                // completion(.failure(APIError))
                return
            }
            
            guard let data = data else {
                print("Error: data is empty")
                // completion(.failure(APIError))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                // 코드 번호에 따라 적절한 에러 발생 시켜야함
                print("Error: HTTP request failed")
                // completion(.failure(APIError))
                return
            }
            
            guard (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed (code:\(response.statusCode))")
                return
            }
            
            completion(.success(data))
            
        }.resume()
    }
}
