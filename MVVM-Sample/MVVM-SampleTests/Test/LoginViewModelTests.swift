
//  LoginPresenterTests.swift
//  MVVM-SampleTests
//
//  Created by lyhonghwa on 2018. 8. 2..
//  Copyright © 2018년 lyhonghwa. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa

@testable import MVVM_Sample

class LoginViewModelTests: XCTestCase {
    typealias LoginDataType = LoginViewModel.LoginDataType
    typealias LoginStatus = LoginViewModel.LoginStatus
    
    var stubLoginService: StubLoginService!
    var loginViweModel: LoginViewModel!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        stubLoginService = StubLoginService()
        loginViweModel = LoginViewModel(service: stubLoginService)
        disposeBag = DisposeBag()
    }
    
    //next field trigger -> next field
    func test_transform_nextFieldTriggerInvoked_nextFieldEmited() {
        //given
        let trigger = PublishSubject<Void>()
        let input = createInput(nextFieldTrigger: trigger)
        let output = loginViweModel.transform(input: input)
        var isNextFieldEmited = false
        
        //when
        output.nextField.do(onNext: { isNextFieldEmited = true }).drive().disposed(by: disposeBag)
        trigger.onNext(())
        
        //then
        XCTAssertTrue(isNextFieldEmited)
    }
    
    //editing changed -> reset background color
    func test_transform_editingChangedInvoked_resetBackgroundColorEmited() {
        //given
        let trigger = PublishSubject<Void>()
        let input = createInput(editingChanged: trigger)
        let output = loginViweModel.transform(input: input)
        var isResetBackgroundColorEmited = false
        
        //when
        output.resetBackgroundColor.do(onNext: { isResetBackgroundColorEmited = true }).drive().disposed(by: disposeBag)
        trigger.onNext(())
    
        //then
        XCTAssertTrue(isResetBackgroundColorEmited)
    }
    
    //login trigger (username) -> failed login
    func test_transform_failedUsernameLoginTriggerInvoked_failedLoginEimited() {
        //given
        stubLoginService.result = .failure(.username)
        let dummyData: LoginDataType = (id: "dummy", pw: "dummy")
        let trigger = PublishSubject<LoginDataType>()
        let input = createInput(loginTrigger: trigger)
        let output = loginViweModel.transform(input: input)
        var error: LoginStatus?
        
        //when
        output.failedLogin.do(onNext: { status in
            error = status
        })
            .drive()
            .disposed(by: disposeBag)
        trigger.onNext(dummyData)
        
        //then
        XCTAssertTrue(error == .wrongUsername)
    }
    
    //login trigger (username) -> failed login
    func test_transform_failedPasswordLoginTriggerInvoked_failedLoginEimited() {
        //given
        stubLoginService.result = .failure(.password)
        let dummyData: LoginDataType = (id: "dummy", pw: "dummy")
        let trigger = PublishSubject<LoginDataType>()
        let input = createInput(loginTrigger: trigger)
        let output = loginViweModel.transform(input: input)
        var error: LoginStatus?
        
        //when
        output.failedLogin.do(onNext: { status in
            error = status
        })
            .drive()
            .disposed(by: disposeBag)
        trigger.onNext(dummyData)
        
        //then
        XCTAssertTrue(error == .wrongPassword)
    }


    //login trigger -> success login
    func test_transform_successLoginTriggerInvoked_successLoginEimited() {
        //given
        let dummyUser = User()
        stubLoginService.result = .success(dummyUser)
        let dummyData: LoginDataType = (id: "dummy", pw: "dummy")
        let trigger = PublishSubject<LoginDataType>()
        let input = createInput(loginTrigger: trigger)
        let output = loginViweModel.transform(input: input)
        var isSuccessLoginEimited = false
        
        //when
        output.successLogin.do(onNext: { isSuccessLoginEimited = true }).drive().disposed(by: disposeBag)
        trigger.onNext((dummyData))
        
        //then
        XCTAssertTrue(isSuccessLoginEimited)
    }
    
    //convenience method
    private func createInput(loginTrigger: Observable<LoginDataType> = Observable.never(),
                             nextFieldTrigger: Observable<Void> = Observable.never(),
                             editingChanged: Observable<Void> = Observable.never()) -> LoginViewModel.Input {
        
        return LoginViewModel.Input(loginTrigger: loginTrigger.asDriverOnErrorJustComplete,
                                    nextFieldTrigger: nextFieldTrigger.asDriverOnErrorJustComplete,
                                    editingChanged: editingChanged.asDriverOnErrorJustComplete)
    }
}
