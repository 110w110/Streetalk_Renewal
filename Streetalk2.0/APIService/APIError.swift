//
//  APIError.swift
//  Streetalk2.0
//
//  Created by 한태희 on 2023/06/09.
//

import Foundation

public enum APIError: Error {
    case invalidUrl
    case invalidRequest
    case requestDataIsEmpty
    case httpNetworkRequestError
    case invalidCredential
    case dataDecodingError
    case requestCouldNotBeCompleted
}
