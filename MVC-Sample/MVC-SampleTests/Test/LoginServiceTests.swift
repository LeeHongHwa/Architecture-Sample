//
//  LoginServiceTests.swift
//  MVC-SampleTests
//
//  Created by david on 2018. 8. 2..
//  Copyright © 2018년 lyhonghwa. All rights reserved.
//

import XCTest
@testable import MVC_Sample

private func httpURLResponse(forStatusCode statusCode: Int, headers: [String: String] = [:]) -> HTTPURLResponse {
    let url = URL(string: "https://httpbin.org/get")!
    return HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: "HTTP/1.1", headerFields: headers)!
}

class LoginServiceTests: XCTestCase {
    
    var loginService: LoginService!
    var session: StubURLSession!
    
    override func setUp() {
        super.setUp()
        session = StubURLSession()
        loginService = LoginService(session: session)
    }
    
    //아이디 빈 값인가
    func testEmptyLoginData_emptyUsername_call() {
        //given
        let username = ""
        let password = "1"
        
        //when
        let error = loginService.emptyLoginData(username: username, password: password)
        
        //then
        XCTAssertTrue(error == .username)
    }
    
    //비밀번호 빈 값인가
    func testEmptyLoginData_emptyPassword_call() {
        //given
        let username = "d"
        let password = ""
        
        //when
        let error = loginService.emptyLoginData(username: username, password: password)
        
        //then
        XCTAssertTrue(error == .password)
    }
    
    //아이디 비밀번호 충족
    func testEmptyLoginData_notEmpty_call() {
        //given
        let username = "d"
        let password = "1"
        
        //when
        let error = loginService.emptyLoginData(username: username, password: password)
        
        //then
        XCTAssertNil(error)
    }
    
    //아이디가 맞는가
    func testCheckLoginStatus_errorUsername_call() {
        //given
        let username = ""
        let password = "1234"
        
        //when
        let error = loginService.checkLoginStatus(username: username, password: password)
        
        //then
        XCTAssertTrue(error == .username)
    }
    
    //비밀번호가 맞는가
    func testCheckLoginStatus_errorPassword_call() {
        //given
        let username = "david"
        let password = ""
        
        //when
        let error = loginService.checkLoginStatus(username: username, password: password)
        
        //then
        XCTAssertTrue(error == .password)
    }
    
    //로그인 성공
    func testCheckLoginStatus_success_call() {
        //given
        let username = "david"
        let password = "1234"
        
        //when
        let error = loginService.checkLoginStatus(username: username, password: password)
        
        //then
        XCTAssertNil(error)
    }
    
    //request 설정 여부
    func testRequest_validation_call() {
        //given
        let method = "POST"
        let header = ["Accept": "application/json", "Content-Type": "text/plain"]
        
        //when
        let request = loginService.request(method: method, header: header)
        
        //then
        XCTAssertEqual(request.httpMethod, method)
        XCTAssertEqual(request.value(forHTTPHeaderField: "Accept"), header["Accept"])
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), header["Content-Type"])
    }
    
    //로그인 300 내려줬을때 request failed 반환해 주는가
    func testLogin_returnErrorRequestFailed_whenGetResponse300() {
        //given
        let expectation = self.expectation(description: "status 300")
        let timeout: TimeInterval = 30.0
        let dummyResponse = httpURLResponse(forStatusCode: 300)
        let dummyData = """
        {
            "json": {
                username: "david",
                password: "1234",
            }
        }
        """.data(using: .utf8)!
        let dummyUser = User(username: "david",
                             password: "1234")
        
        //when
        session.result = DummyNetworkResult(data: dummyData, response: dummyResponse, error: nil)
        
        //then
        loginService.login(username: dummyUser.username,
                           password: dummyUser.password) { (result) in
                            switch result {
                            case let .failure(error):
                                switch error {
                                case .requestFailed(_, _):
                                    XCTAssert(true)
                                default:
                                    XCTAssert(false)
                                }
                                
                            default:
                                XCTAssert(false)
                            }
                            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeout)
    }
}
