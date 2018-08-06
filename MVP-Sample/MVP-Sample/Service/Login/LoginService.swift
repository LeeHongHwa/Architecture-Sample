//
//  LoginService.swift
//  MVP-Sample
//
//  Created by lyhonghwa on 2018. 8. 1..
//  Copyright © 2018년 lyhonghwa. All rights reserved.
//

import Foundation

protocol LoginServiceType {
    func login(username: String?, password: String?, completion: @escaping (ServiceResult<User, LoginServiceError>) -> Void)
}

final class LoginService: LoginServiceType {
    
    static let baseURL: URL = URL(string: "https://httpbin.org/post")!
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    public func emptyLoginData(username: String?, password: String?) -> LoginServiceError? {
        guard let username = username, !username.isEmpty else { return .username }
        guard let password = password, !password.isEmpty else { return .password }
        return nil
    }
    
    public func checkLoginStatus(username: String?, password: String?) -> LoginServiceError? {
        switch (username, password) {
        case ("david", "1234"):
            return nil
        case ("david", _):
            return .password
        default:
            return .username
        }
    }
    
    public func request(url: URL = baseURL, method: String, header: [String: String]) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        header.forEach { (field, value) in
            request.setValue(value, forHTTPHeaderField: field)
        }
        return request
    }
    
    public func login(username: String?, password: String?, completion: @escaping (ServiceResult<User, LoginServiceError>) -> Void) {
        //check validation
        if let error = emptyLoginData(username: username, password: password) {
            completion(.failure(error))
            return
        }
        //reqeust
        var request = self.request(method: "POST", header: ["Accept": "application/json", "Content-Type": "text/plain"])
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: ["username": username, "password": password], options: [])
        } catch let error {
            completion(.failure(.encode(error)))
        }
        
        //task
        session.dataTask(with: request) { (data, response, error) in
            guard let response = response as? HTTPURLResponse, let data = data else { completion(.failure(.unknown)); return}
            DispatchQueue.main.async { [weak self] in
                guard let weakSelf = self else { return }
                guard 200..<300 ~= response.statusCode else { completion(.failure(.requestFailed(response: response, data: data))); return }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! JSONObject
                    let userJson = json["json"] as! JSONObject
                    let user = User(json: userJson)
                    if let error = weakSelf.checkLoginStatus(username: user.username, password: user.password) {
                        completion(.failure(error))
                        return
                    }
                    
                    completion(.success(user))
                } catch let error {
                    completion(.failure(.decode(error)))
                }
                }
            }
        .resume()
    }
}
