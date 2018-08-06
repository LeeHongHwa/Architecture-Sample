//
//  ViewType.swift
//  MVC-Sample
//
//  Created by david on 2018. 7. 31..
//  Copyright © 2018년 lyhonghwa. All rights reserved.
//

import UIKit

protocol ViewType: class {
    associatedtype T: UIViewController, ControllerType
    
    weak var controller: T! { get set }
    func setupUI()
    func setupLayout()
    func setupBinding()
    func updateUI<T: ModelType>(with model: T)
}

extension ViewType where Self: UIView {
    static func create(with controller: T) -> Self {
        let `self` = Self()
        self.controller = controller
        self.setupUI()
        self.setupLayout()
        self.setupBinding()
        return self
    }
}
