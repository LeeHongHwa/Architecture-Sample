//
//  LoginViewController.swift
//  MVC-Sample
//
//  Created by david on 2018. 7. 31..
//  Copyright © 2018년 lyhonghwa. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController, ControllerType {
    
    typealias T = LoginView
    typealias U = User
    
    var model: U
    let service: LoginServiceType
    
    required init(model: U = User(), service: LoginServiceType = LoginService()) {
        self.model = model
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = LoginView.create(with: self)
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
                        weakSelf.model.updateUI(with: weakSelf.rootView)
        }
    }
    
    @objc func didTapLoginButton(_ sender: UIButton) {
        let username = rootView.usernameTextField.text
        let password = rootView.passwordTextField.text
        
        login(username: username, password: password)
    }
    
    @objc func didTapUsernameReturnButton(_ sender: UITextField) {
        rootView.usernameTextField.becomeFirstResponder()
    }
    
    @objc func didTapPasswordReturnButton(_ sender: UITextField) {
        let username = rootView.usernameTextField.text
        let password = sender.text
        
        login(username: username, password: password)
    }
    
    @objc func editingChangedTextField(_ sender: UITextField) {
        sender.backgroundColor = nil
    }
}
