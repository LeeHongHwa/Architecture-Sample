//
//  ServiceResult.swift
//  MVC-Sample
//
//  Created by lyhonghwa on 2018. 8. 1..
//  Copyright © 2018년 lyhonghwa. All rights reserved.
//

import Foundation

enum ServiceResult<T, U> where U: Error {
    case success(T)
    case failure(U)
}
