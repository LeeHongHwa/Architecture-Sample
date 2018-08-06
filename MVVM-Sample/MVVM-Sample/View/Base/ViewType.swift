//
//  ViewType.swift
//  MVVM-Sample
//
//  Created by david on 2018. 7. 31..
//  Copyright © 2018년 lyhonghwa. All rights reserved.
//

import UIKit
import RxSwift

protocol ViewType: class {
    associatedtype T: ViewModelType
    
    var viewModel: T! { get set }
    var disposeBag: DisposeBag! { get set }
    
    func setupUI()
    func setupLayout()
    func setupBinding()
}

extension ViewType where Self: UIViewController {
    
    static func create(with viewModel: T) -> Self {
        let `self` = Self()
        self.viewModel = viewModel
        self.disposeBag = DisposeBag()
        self.setupUI()
        self.setupLayout()
        self.setupBinding()
        return self
    }
}
