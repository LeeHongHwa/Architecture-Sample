//
//  LoginViewController.swift
//  MVVM-SampleTests
//
//  Created by lyhonghwa on 2018. 8. 6..
//  Copyright © 2018년 lyhonghwa. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa

@testable import MVVM_Sample

class LoginViewControllerTests: XCTestCase {
    
    typealias LoginStatus = LoginViewModel.LoginStatus
    
    var loginViweModel: StubLoginViewModel!
    
    override func setUp() {
        super.setUp()
        loginViweModel = StubLoginViewModel()
    }
    
    func test_setupBinding_nextFieldInvoked_updateUI() {
        //given
        let trigger = PublishSubject<Void>()
        let output = createOutput(nextField: trigger)
        loginViweModel.output = output
    
        let view = LoginViewController.create(with: loginViweModel)
        UIApplication.shared.keyWindow?.rootViewController = view
        let passwordTextField = view.passwordTextField
        
        //when
        trigger.onNext(())
        
        //then
        XCTAssertTrue(passwordTextField.isFirstResponder)
    }
    
    func test_setupBinding_resetBackgroundColorInvoked_updateUI() {
        //given
        let trigger = PublishSubject<Void>()
        let output = createOutput(resetBackgroundColor: trigger)
        loginViweModel.output = output
        
        let view = LoginViewController.create(with: loginViweModel)
        
        //when
        trigger.onNext(())
        
        //then
        XCTAssertNil(view.usernameTextField.backgroundColor)
        XCTAssertNil(view.passwordTextField.backgroundColor)
    }
    
    func test_setupBinding_successLoginInvoked_updateUI() {
        //given
        let trigger = PublishSubject<Void>()
        let output = createOutput(successLogin: trigger)
        loginViweModel.output = output
        
        let view = LoginViewController.create(with: loginViweModel)
        let usernameTextField = view.usernameTextField
        let passwordTextField = view.passwordTextField
        let loginButton = view.loginButton
        let successLabel = view.successLabel
        
        //when
        trigger.onNext(())
        
        //then
        XCTAssertTrue(usernameTextField.isHidden)
        XCTAssertTrue(passwordTextField.isHidden)
        XCTAssertTrue(loginButton.isHidden)
        XCTAssertFalse(successLabel.isHidden)
    }
    
    func test_setupBinding_failedUsernameLoginInvoked_updateUI() {
        //given
        let trigger = PublishSubject<LoginStatus>()
        let output = createOutput(failedLogin: trigger)
        loginViweModel.output = output
        
        let view = LoginViewController.create(with: loginViweModel)
        UIApplication.shared.keyWindow?.rootViewController = view
        let usernameTextField = view.usernameTextField
        let originalBackgroundColor = usernameTextField.backgroundColor
        
        //when
        trigger.onNext(.wrongUsername)
        
        //then
        XCTAssert(usernameTextField.backgroundColor != originalBackgroundColor)
        XCTAssertTrue(usernameTextField.isFirstResponder)
    }
    
    func test_setupBinding_failedPasswordLoginInvoked_updateUI() {
        //given
        let trigger = PublishSubject<LoginStatus>()
        let output = createOutput(failedLogin: trigger)
        loginViweModel.output = output
        
        let view = LoginViewController.create(with: loginViweModel)
        UIApplication.shared.keyWindow?.rootViewController = view
        let passwordTextField = view.passwordTextField
        let originalBackgroundColor = passwordTextField.backgroundColor

        //when
        trigger.onNext(.wrongPassword)

        //then
        XCTAssert(passwordTextField.backgroundColor != originalBackgroundColor)
        XCTAssertTrue(passwordTextField.isFirstResponder)
    }
    
    //convenience method
    private func createOutput(nextField: Observable<Void> = Observable.never(),
                              resetBackgroundColor: Observable<Void> = Observable.never(),
                              successLogin: Observable<Void> = Observable.never(),
                              failedLogin: Observable<LoginStatus> = Observable.never()) -> LoginViewModel.Output {
        return LoginViewModel.Output(nextField: nextField.asDriverOnErrorJustComplete,
                                     resetBackgroundColor: resetBackgroundColor.asDriverOnErrorJustComplete,
                                     successLogin: successLogin.asDriverOnErrorJustComplete,
                                     failedLogin: failedLogin.asDriverOnErrorJustComplete)
    }
}

