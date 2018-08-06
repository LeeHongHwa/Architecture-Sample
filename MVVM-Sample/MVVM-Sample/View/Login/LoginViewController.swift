//
//  LoginViewController.swift
//  MVVM-Sample
//
//  Created by david on 2018. 7. 31..
//  Copyright © 2018년 lyhonghwa. All rights reserved.
//

import RxSwift
import RxCocoa

final class LoginViewController: UIViewController, ViewType {
    
    //MARK: - ViewModel
    typealias T = LoginViewModel
    var viewModel: T!
    
    var disposeBag: DisposeBag!
    
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
        //-> input
        let didTapLoginButton = loginButton.rx.tap.asObservable()
        
        let didTapPasswordReturnButton = passwordTextField.rx.editingDidEndOnExit.asObservable()
        
        let editingChangedTextFields = [usernameTextField, passwordTextField]
            .map { $0.rx.editingChanged.asObservable() }
        
        let loginTrigger = Observable<Void>
            .merge([didTapLoginButton, didTapPasswordReturnButton])
            .withLatestFrom(usernameTextField.rx.text)
            .withLatestFrom(passwordTextField.rx.text) { (username, password) -> (LoginViewModel.LoginDataType) in
                return (username, password)
            }
            .asDriver(onErrorDriveWith: Driver.empty())
        
        let editingChanged = Observable<Void>
            .merge(editingChangedTextFields)
            .asDriver(onErrorDriveWith: Driver.empty())
        
        let input = LoginViewModel.Input(loginTrigger: loginTrigger,
                                         nextFieldTrigger: usernameTextField.rx.editingDidEndOnExit.asDriver(),
                                         editingChanged: editingChanged)
        
        //<- output
        let output = viewModel.transform(input: input)
        
        output.nextField.drive(onNext: { [weak self] _ in
            guard let weakSelf = self, !weakSelf.passwordTextField.isFirstResponder else { return }
            weakSelf.passwordTextField.becomeFirstResponder()
        })
        .disposed(by: disposeBag)
        
        output.resetBackgroundColor.drive(onNext: { [weak self] _ in
            guard let weakSelf = self else { return }
            weakSelf.usernameTextField.backgroundColor = nil
            weakSelf.passwordTextField.backgroundColor = nil
            
        })
        .disposed(by: disposeBag)
        
        output.successLogin.drive(onNext: { [weak self] _ in
            guard let weakSelf = self else { return }
            weakSelf.updateLoginArea(type: .success)
        })
        .disposed(by: disposeBag)
        
        output.failedLogin.drive(onNext: { [weak self] loginError in
            guard let weakSelf = self else { return }
            weakSelf.updateLoginArea(type: loginError)
        })
        .disposed(by: disposeBag)
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
