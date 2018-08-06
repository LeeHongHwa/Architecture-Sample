//
//  ControllerType.swift
//  MVC-Sample
//
//  Created by david on 2018. 7. 31..
//  Copyright © 2018년 lyhonghwa. All rights reserved.
//

import UIKit

protocol ControllerType: class {
    associatedtype T: ViewType
    associatedtype U: ModelType
    
    var rootView: T { get }
    var model: U { get set }
}

extension ControllerType where Self: UIViewController {
    var rootView: T {
        get {
            return view as! T
        }
    }
}
