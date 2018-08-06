//
//  ViewType.swift
//  MVP-Sample
//
//  Created by david on 2018. 7. 31..
//  Copyright © 2018년 lyhonghwa. All rights reserved.
//

import UIKit

protocol ViewType: class {
    associatedtype T: PresenterType
    
    var presenter: T! { get set }
    
    func setupUI()
    func setupLayout()
    func setupBinding()
}

extension ViewType where Self: UIViewController {
    
    init(with presenter: T) {
        self.init()
        self.presenter = presenter
        self.presenter.view = self as? Self.T.T
    }
    
    static func create(with presenter: T) -> Self {
        let `self` = Self(with: presenter)
        self.presenter = presenter
        self.setupUI()
        self.setupLayout()
        self.setupBinding()
        return self
    }
}
