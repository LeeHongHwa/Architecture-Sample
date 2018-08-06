//
//  Driver+Empty.swift
//  MVVM-Sample
//
//  Created by lyhonghwa on 2018. 8. 6..
//  Copyright © 2018년 lyhonghwa. All rights reserved.
//

import RxSwift
import RxCocoa

extension ObservableType {
    var asDriverOnErrorJustComplete: Driver<E> {
        return asDriver { error in
            return Driver.empty()
        }
    }
}
