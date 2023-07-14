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
    
    private func createRequest(url: String, method: HttpMethods, header: [String : String]) -> URLRequest? {
        guard let url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: url) else {
            print("Error: cannot create URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = timeoutInterval
        
        for item in header {
            request.setValue(item.key, forHTTPHeaderField: item.value)
        }
        
        return request
    }
    
    func request(data: Data? = nil, url: String, method: HttpMethods, header: [String : String],  param: [String : Any]?, completion: @escaping (Result<Data, APIError>) -> Void) {
        
        guard var request = createRequest(url: url, method: method, header: header) else {
            completion(.failure(.createRequestFail))
            return
        }
        
        if let data = data {
            request.httpBody = data
        } else {
            if let param = param {
                request.httpBody = try? JSONSerialization.data(withJSONObject: param, options: [])
            }
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                print("Error: request failed \(error)")
                completion(.failure(.invalidRequest))
                return
            }
            
            guard let data = data else {
                print("Error: data is empty")
                completion(.failure(.requestDataIsEmpty))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                // 코드 번호에 따라 적절한 에러 발생 시켜야함
                print("Error: HTTP request failed")
                completion(.failure(.httpNetworkRequestError))
                return
            }
            
            guard (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed (code:\(response.statusCode))")
                
                switch response.statusCode {
                case (100 ..< 199):
                    completion(.failure(.httpInformation1xxError))
                case (300 ..< 399):
                    completion(.failure(.httpRedirection3xxError))
                case (400 ..< 499):
                    print(response)
                    completion(.failure(.httpClient4xxError))
                case (500 ..< 599):
                    print(response)
                    completion(.failure(.httpServer5xxError))
                default:
                    completion(.failure(.httpNetworkRequestError))
                }
                
                return
            }
            
            completion(.success(data))
            
        }.resume()
    }
    
}
