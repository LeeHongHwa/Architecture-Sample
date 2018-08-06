//
//  ModelType.swift
//  MVC-Sample
//
//  Created by lyhonghwa on 2018. 8. 1..
//  Copyright © 2018년 lyhonghwa. All rights reserved.
//
import UIKit

typealias JSONObject = [String: Any]

protocol ModelType {
    init(json: JSONObject)
    func updateUI<T: ViewType>(with view: T)
}

extension ModelType {
    func updateUI<T: ViewType>(with view: T) {
        view.updateUI(with: self)
    }
}
