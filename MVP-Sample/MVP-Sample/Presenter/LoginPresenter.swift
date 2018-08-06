//
//  LoginPresenter.swift
//  MVP-Sample
//
//  Created by lyhonghwa on 2018. 8. 3..
//  Copyright © 2018년 lyhonghwa. All rights reserved.
//

import UIKit

protocol LoginPresenterType: PresenterType {
    func didTapLoginButton(_ sender: UIButton)
    func didTapUsernameReturnButton(_ sender: UITextField)
    func didTapPasswordReturnButton(_ sender: UITextField)
    func editingChangedTextField(_ sender: UITextField)
}

class LoginPresenter: LoginPresenterType {
    typealias T = LoginViewController
    typealias U = User
    
    weak var view: T?
    var model: U
    let service: LoginServiceType
    
    required init(model: U = User(), service: LoginServiceType = LoginService()) {
        self.model = model
        self.service = service
    }
    
    func login(username: String? = nil, password: String? = nil) {
        service.login(username: username,
                      password: password) { [weak self] result in
                        guard let weakSelf = self else { return }
                        switch result {
                        case let .success(data):
                            weakSelf.model.update(with: data)
                            weakSelf.model.loginStatus = .success
                        case let .failure(reason):
                            reason.print()
                            switch reason {
                            case .username:
                                weakSelf.model.loginStatus = .wrongUsername
                            case .password:
                                weakSelf.model.loginStatus = .wrongPassword
                            default:
                                return
                            }
                        }
                        guard let loginStatus = weakSelf.model.loginStatus else { return }
                        weakSelf.updateLoginArea(type: loginStatus)
        }
    }
    
    @objc func didTapLoginButton(_ sender: UIButton) {
        let username = view?.usernameTextField.text
        let password = view?.passwordTextField.text
        
        login(username: username, password: password)
    }
    
    @objc func didTapUsernameReturnButton(_ sender: UITextField) {
        view?.usernameTextField.becomeFirstResponder()
    }
    
    @objc func didTapPasswordReturnButton(_ sender: UITextField) {
        let username = view?.usernameTextField.text
        let password = sender.text
        
        login(username: username, password: password)
    }
    
    @objc func editingChangedTextField(_ sender: UITextField) {
        sender.backgroundColor = nil
    }
    
    private func focusTextField(type: User.LoginStatus) {
        switch type {
        case .wrongUsername:
            view?.usernameTextField.becomeFirstResponder()
        case .wrongPassword:
            view?.passwordTextField.becomeFirstResponder()
        default:
            return
        }
    }
    
    private func setTextFieldBackgroundColor(type: User.LoginStatus) {
        switch type {
        case .wrongUsername:
            view?.usernameTextField.backgroundColor = UIColor.gray
        case .wrongPassword:
            view?.passwordTextField.backgroundColor = UIColor.gray
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
        [view?.usernameTextField, view?.passwordTextField, view?.loginButton].forEach { $0?.isHidden = isLogin }
        view?.successLabel.isHidden = !isLogin
        setErrorTextField(type: type)
    }
}
