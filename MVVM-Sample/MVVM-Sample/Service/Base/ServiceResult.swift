//
//  ServiceResult.swift
//  MVVM-Sample
//
//  Created by lyhonghwa on 2018. 8. 1..
//  Copyright © 2018년 lyhonghwa. All rights reserved.
//

import Foundation

enum ServiceResult<T, U> where U: Error {
    case success(T)
    case failure(U)
    
    var isSuccess: Bool {
        switch self {
        case .success(_):
            return true
        case .failure(_):
            return false
        }
    }
    
    var error: U? {
        switch self {
        case .success(_):
            return nil
        case let .failure(error):
            return error
        }
    }
}

extension ServiceResult: Equatable {
    static func == (lhs: ServiceResult<T, U>, rhs: ServiceResult<T, U>) -> Bool {
        switch (lhs, rhs) {
        case (.success(_), .success(_)),
             (.failure(_), .failure(_)):
            return true
        default:
            return false
        }
    }
}
