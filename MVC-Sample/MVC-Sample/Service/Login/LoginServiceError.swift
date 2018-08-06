//
//  LoginServiceError.swift
//  MVC-Sample
//
//  Created by lyhonghwa on 2018. 8. 1..
//  Copyright © 2018년 lyhonghwa. All rights reserved.
//

import Foundation

enum LoginServiceError: Error {
    case unknown
    case username
    case password
    case requestFailed(response: URLResponse, data: Data?)
    case encode(Error)
    case decode(Error)
    
    func print() {
        var errorString = "[Login Error] "
        switch self {
        case .unknown:
            errorString += "unkonwn"
        case .username:
            errorString += "wrong username"
        case .password:
            errorString += "wrong password"
        case .requestFailed(let response, let data):
            errorString += "request failed\nresponse: \(response)\ndata: \(String(describing: data))"
        case let .encode(error):
            errorString += "encode: \(error.localizedDescription)"
        case let .decode(error):
            errorString += "decode: \(error.localizedDescription)"
        }
        Swift.print(errorString)
    }
}

extension LoginServiceError: Equatable {
    static func == (lhs: LoginServiceError, rhs: LoginServiceError) -> Bool {
        switch (lhs, rhs) {
        case (.unknown, .unknown),
             (.username, .username),
             (.password, .password),
             (.requestFailed(_), .requestFailed(_)),
             (.encode(_), .encode(_)),
             (.decode(_), .decode(_)):
            return true
        default:
            return false
        }
    }
}
