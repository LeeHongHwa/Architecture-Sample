//
//  StubLoginViewModel.swift
//  MVVM-SampleTests
//
//  Created by lyhonghwa on 2018. 8. 6..
//  Copyright © 2018년 lyhonghwa. All rights reserved.
//

import RxSwift
import RxCocoa

@testable import MVVM_Sample

class StubLoginViewModel: LoginViewModel {
    
    var output: Output!
    
    convenience init() {
        self.init(service: StubLoginService())
    }

    override func transform(input: Input) -> Output {
        return output
    }
}
