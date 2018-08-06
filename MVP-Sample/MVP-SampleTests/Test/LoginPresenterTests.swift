
//  LoginPresenterTests.swift
//  MVP-SampleTests
//
//  Created by lyhonghwa on 2018. 8. 2..
//  Copyright © 2018년 lyhonghwa. All rights reserved.
//

import XCTest
@testable import MVP_Sample

class LoginPresenterTests: XCTestCase {
    
    var stubLoginService: StubLoginService!
    var presenter: LoginPresenter!
    var view: LoginViewController!
    
    override func setUp() {
        super.setUp()
        stubLoginService = StubLoginService()
        presenter = LoginPresenter(service: stubLoginService)
        view = LoginViewController.create(with: presenter)
        UIApplication.shared.keyWindow?.rootViewController = view
    }
    
    //로그인 실패시 아이디가 틀리면 아이디 텍스트 필드가 회색이 되고 초점이 맞춰지는가
    func testUsernameTextField_updateUI_whenFailedLogin() {
        //given
        let usernameTextField = view.usernameTextField
        let originalBackgroundColor = usernameTextField.backgroundColor
        stubLoginService.result = .failure(.username)
        
        //when
        presenter.login()
        
        //then
        XCTAssert(usernameTextField.backgroundColor != originalBackgroundColor)
        XCTAssertTrue(usernameTextField.isFirstResponder)
    }

    //비밀번호 텍스트 필드에서 리턴을 눌렀을때 로그인을 시도하는가?
    func testPasswordTextField_tryLogin_whenReturn() {
        //given
        let passwordTextField = view.passwordTextField

        //when
        passwordTextField.sendActions(for: .editingDidEndOnExit)

        //then
        XCTAssertTrue(stubLoginService.isLoginExecuted)
    }

    //로그인 실패시 비밀번호가 틀리면 비밀번호 텍스트 필드가 회색이 되고 초점이 맞춰지는가
    func testPasswordTextField_updateUI_whenFailedLogin() {
        //given
        let passwordTextField = view.passwordTextField
        let originalBackgroundColor = passwordTextField.backgroundColor
        stubLoginService.result = .failure(.password)

        //when
        presenter.login()

        //then
        XCTAssert(passwordTextField.backgroundColor != originalBackgroundColor)
        XCTAssertTrue(passwordTextField.isFirstResponder)
    }

    //로그인 버튼을 눌렀을때 로그인을 시도하는가?
    func testLoginButton_tryLogin_whenTapButton() {
        //given
        let loginButton = view.loginButton

        //when
        loginButton.sendActions(for: .touchUpInside)

        //then
        XCTAssertTrue(stubLoginService.isLoginExecuted)
    }

    //로그인 성공시 area가 사라지고 text가 나오는가
    func testAllUI_updateUI_whenSuccessLogin() {
        //given
        let usernameTextField = view.usernameTextField
        let passwordTextField = view.passwordTextField
        let loginButton = view.loginButton
        let successLabel = view.successLabel
        let dummyUser = User()
        stubLoginService.result = .success(dummyUser)

        //when
        presenter.login()

        //then
        XCTAssertTrue(usernameTextField.isHidden)
        XCTAssertTrue(passwordTextField.isHidden)
        XCTAssertTrue(loginButton.isHidden)
        XCTAssertFalse(successLabel.isHidden)
    }
}
