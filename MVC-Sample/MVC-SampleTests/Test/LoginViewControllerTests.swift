
//  LoginViewControllerTests.swift
//  MVC-SampleTests
//
//  Created by lyhonghwa on 2018. 8. 2..
//  Copyright © 2018년 lyhonghwa. All rights reserved.
//

import XCTest
@testable import MVC_Sample

class LoginViewControllerTests: XCTestCase {
    
    var viewController: LoginViewController!
    var stubLoginService: StubLoginService!
    
    override func setUp() {
        super.setUp()
        stubLoginService = StubLoginService()
        viewController = LoginViewController(service: stubLoginService)
        UIApplication.shared.keyWindow?.rootViewController = viewController
    }
    
    //로그인 실패시 아이디가 틀리면 아이디 텍스트 필드가 회색이 되고 초점이 맞춰지는가
    func testUsernameTextField_updateUI_whenFailedLogin() {
        //given
        let usernameTextField = viewController.rootView.usernameTextField
        let originalBackgroundColor = usernameTextField.backgroundColor
        self.stubLoginService.result = .failure(.username)
        
        //when
        viewController.login()
        
        //then
        XCTAssert(usernameTextField.backgroundColor != originalBackgroundColor)
        XCTAssertTrue(usernameTextField.isFirstResponder)
    }

    //비밀번호 텍스트 필드에서 리턴을 눌렀을때 로그인을 시도하는가?
    func testPasswordTextField_tryLogin_whenReturn() {
        //given
        let passwordTextField = viewController.rootView.passwordTextField

        //when
        passwordTextField.sendActions(for: .editingDidEndOnExit)

        //then
        XCTAssertTrue(stubLoginService.isLoginExecuted)
    }

    //로그인 실패시 비밀번호가 틀리면 비밀번호 텍스트 필드가 회색이 되고 초점이 맞춰지는가
    func testPasswordTextField_updateUI_whenFailedLogin() {
        //given
        let passwordTextField = viewController.rootView.passwordTextField
        let originalBackgroundColor = passwordTextField.backgroundColor
        stubLoginService.result = .failure(.password)
        
        //when
        viewController.login()
        
        //then
        XCTAssert(passwordTextField.backgroundColor != originalBackgroundColor)
        XCTAssertTrue(passwordTextField.isFirstResponder)
    }

    //로그인 버튼을 눌렀을때 로그인을 시도하는가?
    func testLoginButton_tryLogin_whenTapButton() {
        //given
        let loginButton = viewController.rootView.loginButton
        
        //when
        loginButton.sendActions(for: .touchUpInside)
        
        //then
        XCTAssertTrue(stubLoginService.isLoginExecuted)
    }

    //로그인 성공시 area가 사라지고 text가 나오는가
    func testAllUI_updateUI_whenSuccessLogin() {
        //given
        let usernameTextField = viewController.rootView.usernameTextField
        let passwordTextField = viewController.rootView.passwordTextField
        let loginButton = viewController.rootView.loginButton
        let successLabel = viewController.rootView.successLabel
        let dummyUser = User()
        stubLoginService.result = .success(dummyUser)
        
        //when
        viewController.login()
        
        //then
        XCTAssertTrue(usernameTextField.isHidden)
        XCTAssertTrue(passwordTextField.isHidden)
        XCTAssertTrue(loginButton.isHidden)
        XCTAssertFalse(successLabel.isHidden)
    }
}
