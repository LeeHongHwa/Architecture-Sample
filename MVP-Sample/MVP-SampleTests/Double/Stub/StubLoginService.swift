//
//  StubLoginService.swift
//  MVP-SampleTests
//
//  Created by lyhonghwa on 2018. 8. 2..
//  Copyright © 2018년 lyhonghwa. All rights reserved.
//

@testable import MVP_Sample

class StubLoginService: LoginServiceType {
    var isLoginExecuted: Bool = false
    var result: ServiceResult<User, LoginServiceError>!
    
    func login(username: String?, password: String?, completion: @escaping (ServiceResult<User, LoginServiceError>) -> Void) {
        isLoginExecuted = true
        
        if let result = result {
            completion(result)
        }
    }
}
