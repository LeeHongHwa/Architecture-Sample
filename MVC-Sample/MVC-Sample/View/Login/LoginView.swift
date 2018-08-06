//
//  LoginView.swift
//  MVC-Sample
//
//  Created by lyhonghwa on 2018. 8. 1..
//  Copyright © 2018년 lyhonghwa. All rights reserved.
//

import UIKit

class LoginView: UIView, ViewType {
    //MARK: - Controller
    typealias T = LoginViewController
    weak var controller: T!
    
    //MARK: - Views
    let usernameTextField = UITextField()
    let passwordTextField = UITextField()
    
    let loginButton = UIButton(type: .system)
    
    let successLabel = UILabel()
    
    //MARK: - Function
    func setupUI() {
        controller.navigationController?.navigationBar.prefersLargeTitles = true
        controller.title = "로그인"
        
        backgroundColor = .white
        
        [(usernameTextField, "username"), (passwordTextField, "password")]
            .forEach { (textField, placeholder) in
            textField.placeholder = placeholder
            textField.borderStyle = .roundedRect
            addSubview(textField)
        }

        passwordTextField.returnKeyType = .go
        passwordTextField.isSecureTextEntry = true
        
        loginButton.setTitle("로그인", for: .normal)
        addSubview(loginButton)
        
        successLabel.text = "성공"
        successLabel.textAlignment = .center
        successLabel.textColor = UIColor.black
        successLabel.font = UIFont.systemFont(ofSize: 24)
        successLabel.isHidden = true
        addSubview(successLabel)
        
        usernameTextField.becomeFirstResponder()
    }
    
    func setupLayout() {
        [(usernameTextField, safeAreaLayoutGuide.topAnchor, UI.bigMargin),
         (passwordTextField, usernameTextField.bottomAnchor, UI.mediumMargin)]
            .forEach { (textField, toTopAnchor, topConstant) in
                textField
                    .topAnchor(to: toTopAnchor, constant: topConstant)
                    .leadingAnchor(to:leadingAnchor, constant: UI.baseMargin)
                    .trailingAnchor(to:trailingAnchor, constant: -UI.baseMargin)
                    .heightAnchor(constant: UI.barHeight)
                    .activateAnchors()
        }
        
        loginButton
            .topAnchor(to: passwordTextField.bottomAnchor, constant: UI.bigMargin)
            .leadingAnchor(to:leadingAnchor, constant: UI.baseMargin)
            .trailingAnchor(to:trailingAnchor, constant: -UI.baseMargin)
            .heightAnchor(constant: UI.barHeight)
            .activateAnchors()
        
        successLabel
            .allDirectionsAnchor(to: self)
    }
    
    func setupBinding() {
        usernameTextField.addTarget(controller, action: #selector(controller.didTapUsernameReturnButton), for: .editingDidEndOnExit)
        passwordTextField.addTarget(controller, action: #selector(controller.didTapPasswordReturnButton), for: .editingDidEndOnExit)
        loginButton.addTarget(controller, action: #selector(controller.didTapLoginButton), for: .touchUpInside)
        [usernameTextField, passwordTextField].forEach {
            $0.addTarget(controller, action: #selector(controller.editingChangedTextField), for: .editingChanged)
        }
    }
    
    func updateUI<T>(with model: T) where T : ModelType {
        guard let model = model as? User, let loginStatus = model.loginStatus else { return }
        updateLoginArea(type: loginStatus)
    }
    
    private func focusTextField(type: User.LoginStatus) {
        switch type {
        case .wrongUsername:
            usernameTextField.becomeFirstResponder()
        case .wrongPassword:
            passwordTextField.becomeFirstResponder()
        default:
            return
        }
    }
    
    private func setTextFieldBackgroundColor(type: User.LoginStatus) {
        switch type {
        case .wrongUsername:
            usernameTextField.backgroundColor = UIColor.gray
        case .wrongPassword:
            passwordTextField.backgroundColor = UIColor.gray
        default:
            return
        }
    }
    
    private func setErrorTextField(type: User.LoginStatus) {
        focusTextField(type: type)
        setTextFieldBackgroundColor(type: type)
    }
    
    private func updateLoginArea(type: User.LoginStatus) {
        let isLogin = (type == .success)
        [usernameTextField, passwordTextField, loginButton].forEach { $0.isHidden = isLogin }
        successLabel.isHidden = !isLogin
        setErrorTextField(type: type)
    }
}
