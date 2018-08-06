//
//  PresenterType.swift
//  MVP-Sample
//
//  Created by lyhonghwa on 2018. 8. 3..
//  Copyright © 2018년 lyhonghwa. All rights reserved.
//

import UIKit

protocol PresenterType {
    associatedtype T: UIViewController, ViewType
    associatedtype U: ModelType
    
    weak var view: T? { get set }
    var model: U { get set }
}
