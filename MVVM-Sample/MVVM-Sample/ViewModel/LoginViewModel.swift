//
//  LoginViewModel.swift
//  MVVM-Sample
//
//  Created by lyhonghwa on 2018. 8. 3..
//  Copyright © 2018년 lyhonghwa. All rights reserved.
//

import RxSwift
import RxCocoa

class LoginViewModel: ViewModelType {
    typealias LoginDataType = (id: String?, pw: String?)
    typealias LoginStatus = User.LoginStatus
    
    init(service: ReactiveLoginServiceType) {
        self.service = service
    }
    
    let service: ReactiveLoginServiceType
    
    struct Input {
        let loginTrigger: Driver<LoginDataType>
        let nextFieldTrigger: Driver<Void>
        let editingChanged: Driver<Void>
    }
    
    struct Output {
        let nextField: Driver<Void>
        let resetBackgroundColor: Driver<Void>
        let successLogin: Driver<Void>
        let failedLogin: Driver<LoginStatus>
    }
    
    func transform(input: Input) -> Output {
        let nextField = input.nextFieldTrigger
            .asDriver(onErrorDriveWith: Driver.empty())
        
        let resetBackgroundColor = input.editingChanged
        
        let loginAPI = input.loginTrigger
            .asObservable()
            .flatMap { [weak self] data -> Observable<ServiceResult<User, LoginServiceError>> in
                guard let weakSelf = self else { return Observable.empty() }
                return weakSelf.service.loginObervable(username: data.id, password: data.pw)
            }
            .share()
            .asDriver(onErrorDriveWith: Driver.empty())
        
        let successLogin = loginAPI
            .filter { result -> Bool in
                return result.isSuccess
            }
            .map { _ -> Void in
                return ()
            }
            .asDriver(onErrorDriveWith: Driver.empty())
        
        let failedLogin = loginAPI
            .filter { result -> Bool in
                return result.error?.loginStatus != nil
            }
            .map { result -> LoginStatus in
                return result.error!.loginStatus!
            }
            .asDriver(onErrorDriveWith: Driver.empty())
        
            return Output(nextField: nextField,
                          resetBackgroundColor: resetBackgroundColor,
                          successLogin: successLogin,
                          failedLogin: failedLogin)
    }
}
