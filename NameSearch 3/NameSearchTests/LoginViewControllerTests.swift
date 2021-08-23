//
//  LoginViewControllerTests.swift
//  NameSearchTests
//
//  Created by Marcus Washington on 8/22/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

import XCTest
@testable import NameSearch

class LoginViewControllerTests: XCTestCase {

    var navC: UINavigationController!
    var loginVC: LoginViewController!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        self.loginVC = LoginViewController()
        self.loginVC.service = MockService()
        self.navC = UINavigationController(rootViewController: self.loginVC)
    }

    override func tearDownWithError() throws {
        self.loginVC = nil
        self.navC = nil
        try super.tearDownWithError()
    }

    func testLogin() {
        let expectation = XCTestExpectation(description: "Returns Login Response from username and password")
        var loginResponse: LoginResponse?
        
        loginVC.login(with: "Hello", password: "World") { (result) in
            switch result {
            case .success(let response):
                loginResponse = response
                expectation.fulfill()
            case .failure:
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 3.0)
        
        XCTAssertEqual(loginResponse?.auth.token, "abcdefg")
        XCTAssertEqual(loginResponse?.user.first, "John")
        XCTAssertEqual(loginResponse?.user.last, "Johnson")
    }

}
