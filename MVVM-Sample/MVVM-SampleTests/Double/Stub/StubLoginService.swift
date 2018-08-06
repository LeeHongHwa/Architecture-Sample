//
//  StubLoginService.swift
//  MVVM-SampleTests
//
//  Created by lyhonghwa on 2018. 8. 2..
//  Copyright © 2018년 lyhonghwa. All rights reserved.
//

import RxSwift
import RxCocoa

@testable import MVVM_Sample

class StubLoginService: ReactiveLoginServiceType {
    
    var isLoginExecuted: Bool = false
    var result: ServiceResult<User, LoginServiceError>!
    
    func loginObervable(username: String?, password: String?) -> Observable<ServiceResult<User, LoginServiceError>> {
        isLoginExecuted = true
        
        if let result = result {
            return Observable.just(result)
        }
        
        return Observable.empty()
    }
}
