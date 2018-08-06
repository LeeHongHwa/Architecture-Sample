//
//  LoginViewController.swift
//  MVP-Sample
//
//  Created by david on 2018. 7. 31..
//  Copyright © 2018년 lyhonghwa. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController, ViewType {
    
    //MARK: - Presenter
    typealias T = LoginPresenter
    var presenter: T!
    
    //MARK: - Views
    let usernameTextField = UITextField()
    let passwordTextField = UITextField()
    
    let loginButton = UIButton(type: .system)
    
    let successLabel = UILabel()
    
    //MARK: - Function
    func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "로그인"
        
        view.backgroundColor = .white
        
        [(usernameTextField, "username"), (passwordTextField, "password")]
            .forEach { (textField, placeholder) in
                textField.placeholder = placeholder
                textField.borderStyle = .roundedRect
                view.addSubview(textField)
        }
        
        passwordTextField.returnKeyType = .go
        passwordTextField.isSecureTextEntry = true
        
        loginButton.setTitle("로그인", for: .normal)
        view.addSubview(loginButton)
        
        successLabel.text = "성공"
        successLabel.textAlignment = .center
        successLabel.textColor = UIColor.black
        successLabel.font = UIFont.systemFont(ofSize: 24)
        successLabel.isHidden = true
        view.addSubview(successLabel)
        
        usernameTextField.becomeFirstResponder()
    }
    
    func setupLayout() {
        [(usernameTextField, view.safeAreaLayoutGuide.topAnchor, UI.bigMargin),
         (passwordTextField, usernameTextField.bottomAnchor, UI.mediumMargin)]
            .forEach { (textField, toTopAnchor, topConstant) in
                textField
                    .topAnchor(to: toTopAnchor, constant: topConstant)
                    .leadingAnchor(to:view.leadingAnchor, constant: UI.baseMargin)
                    .trailingAnchor(to:view.trailingAnchor, constant: -UI.baseMargin)
                    .heightAnchor(constant: UI.barHeight)
                    .activateAnchors()
        }
        
        loginButton
            .topAnchor(to: passwordTextField.bottomAnchor, constant: UI.bigMargin)
            .leadingAnchor(to:view.leadingAnchor, constant: UI.baseMargin)
            .trailingAnchor(to:view.trailingAnchor, constant: -UI.baseMargin)
            .heightAnchor(constant: UI.barHeight)
            .activateAnchors()
        
        successLabel
            .allDirectionsAnchor(to: view)
    }
    
    func setupBinding() {
        usernameTextField.addTarget(presenter, action: #selector(presenter.didTapUsernameReturnButton), for: .editingDidEndOnExit)
        passwordTextField.addTarget(presenter, action: #selector(presenter.didTapPasswordReturnButton), for: .editingDidEndOnExit)
        loginButton.addTarget(presenter, action: #selector(presenter.didTapLoginButton), for: .touchUpInside)
        [usernameTextField, passwordTextField].forEach {
            $0.addTarget(presenter, action: #selector(presenter.editingChangedTextField), for: .editingChanged)
        }
    }
}
