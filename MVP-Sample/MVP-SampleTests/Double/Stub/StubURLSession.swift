//
//  StubURLSession.swift
//  MVP-SampleTests
//
//  Created by lyhonghwa on 2018. 8. 3..
//  Copyright © 2018년 lyhonghwa. All rights reserved.
//

import Foundation

class StubURLSession: URLSession {
    var result: DummyNetworkResult!
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return StubURLSeesionDataTask(completionHandler: completionHandler, result: result)
    }
}
