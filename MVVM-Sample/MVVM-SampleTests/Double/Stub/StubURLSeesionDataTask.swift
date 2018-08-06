//
//  StubURLSeesionDataTask.swift
//  MVVM-SampleTests
//
//  Created by lyhonghwa on 2018. 8. 3..
//  Copyright © 2018년 lyhonghwa. All rights reserved.
//

import Foundation

class StubURLSeesionDataTask: URLSessionDataTask {
    typealias CompletionHandlerType = (Data?, URLResponse?, Error?) -> Void
    
    let completionHandler: CompletionHandlerType
    let result: DummyNetworkResult
    
    init(completionHandler: @escaping CompletionHandlerType, result: DummyNetworkResult) {
        self.completionHandler = completionHandler
        self.result = result
        super.init()
    }
    
    override func resume() {
        completionHandler(result.data, result.response, result.error)
    }
}
