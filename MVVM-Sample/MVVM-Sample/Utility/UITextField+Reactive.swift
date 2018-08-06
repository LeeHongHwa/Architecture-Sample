//
//  UITextField+Reactive.swift
//  MVVM-Sample
//
//  Created by lyhonghwa on 2018. 8. 3..
//  Copyright © 2018년 lyhonghwa. All rights reserved.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UITextField {    
    public var editingDidEndOnExit: ControlEvent<Void> {
        return controlEvent(.editingDidEndOnExit)
    }
    
    public var editingChanged: ControlEvent<Void> {
        return controlEvent(.editingChanged)
    }
}
