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
    case httpInformation1xxError
    case httpRedirection3xxError
    case httpClient4xxError
    case httpServer5xxError
    case invalidCredential
    case dataDecodingError
    case createRequestFail
    case requestCouldNotBeCompleted
}

extension APIError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .invalidUrl:
      return NSLocalizedString("서버가 응답하지 않습니다. 잠시 후 다시 시도해주세요.", comment: "Invalid URL")
    case .invalidRequest:
      return NSLocalizedString("요청을 정상적으로 수행하지 못했습니다. 증상이 지속되면 문의 바랍니다.", comment: "Invalid Request")
    case .requestDataIsEmpty:
      return NSLocalizedString("정상적인 요청이 아닙니다. 증상이 지속되면 문의 바랍니다.", comment: "Request Data is Empty")
    case .httpNetworkRequestError:
      return NSLocalizedString("네트워크 연결에 실패했습니다. 잠시 후 다시 시도해주세요.", comment: "HTTP Network Request Error")
    case .httpInformation1xxError:
      return NSLocalizedString("HTTP 통신 요청에 실패하였습니다. (1)", comment: "HTTP Information 1xx Error")
    case .httpRedirection3xxError:
      return NSLocalizedString("HTTP 통신 요청에 실패하였습니다. (3)", comment: "HTTP Redirection 3xx Error")
    case .httpClient4xxError:
      return NSLocalizedString("클라이언트 요청에 실패하였습니다. (4)", comment: "HTTP Client 4xx Error")
    case .httpServer5xxError:
      return NSLocalizedString("서버가 정상적으로 요청을 수행하지 못했습니다. (5)", comment: "HTTP Server 5xx Error")
    case .invalidCredential:
      return NSLocalizedString("사용자 인증에 실패하였습니다. 증상이 지속되면 문의 바랍니다.", comment: "Invalid Credential")
    case .dataDecodingError:
      return NSLocalizedString("데이터 처리에 실패하였습니다. 증상이 지속되면 문의 바랍니다.", comment: "Data Decoding Error")
    case .createRequestFail:
      return NSLocalizedString("요청을 정상적으로 생성하지 못했습니다. 증상이 지속되면 문의 바랍니다.", comment: "Create Request Fail")
    case .requestCouldNotBeCompleted:
      return NSLocalizedString("요청에 실패했습니다. 증상이 지속되면 문의 바랍니다.", comment: "Request couldn't be completed")
    }
  }
}
