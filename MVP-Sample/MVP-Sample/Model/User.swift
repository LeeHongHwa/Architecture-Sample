//
//  User.swift
//  MVP-Sample
//
//  Created by lyhonghwa on 2018. 8. 1..
//  Copyright © 2018년 lyhonghwa. All rights reserved.
//

import Foundation

struct User: ModelType {
    
    enum LoginStatus {
        case success
        case wrongUsername
        case wrongPassword
    }
    
    var username: String?
    var password: String?
    var loginStatus: LoginStatus?
    
    init() {
        username = nil
        password = nil
        loginStatus = nil
    }
    
    init(json: JSONObject) {
        username = json.asString("username")
        password = json.asString("password")
        loginStatus = nil
    }
    
    init(username: String? = nil, password: String? = nil, loginStatus: LoginStatus? = nil) {
        self.username = username
        self.password = password
        self.loginStatus = loginStatus
    }
    
    mutating func update(with new: User) {
        username = new.username
        password = new.password
        loginStatus = new.loginStatus
    }
}

extension Dictionary {
    func asString(_ key: Key) -> String? {
        return self[key] as? String
    }
}
