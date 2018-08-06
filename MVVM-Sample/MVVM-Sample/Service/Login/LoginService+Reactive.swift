//
//  Rx+LoginService.swift
//  MVVM-Sample
//
//  Created by lyhonghwa on 2018. 8. 3..
//  Copyright © 2018년 lyhonghwa. All rights reserved.
//

import RxSwift

protocol ReactiveLoginServiceType {
    func loginObervable(username: String?, password: String?) -> Observable<ServiceResult<User, LoginServiceError>>
}

extension LoginService: ReactiveLoginServiceType {
    func loginObervable(username: String?, password: String?) -> Observable<ServiceResult<User, LoginServiceError>> {
        return Observable<ServiceResult<User, LoginServiceError>>
            .create { [weak self] observer -> Disposable in
                self?.login(username: username, password: password, completion: { result in
                    observer.onNext(result)
                })
                return Disposables.create()
        }
    }
}
