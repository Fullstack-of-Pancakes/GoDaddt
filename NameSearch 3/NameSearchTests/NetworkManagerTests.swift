//
//  NetworkManagerTests.swift
//  NameSearchTests
//
//  Created by Marcus Washington on 8/22/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

import XCTest
@testable import NameSearch

class NetworkManagerTests: XCTestCase {

    var networkManager: NetworkManager!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        self.networkManager = NetworkManager(session: MockSession())
    }

    override func tearDownWithError() throws {
        self.networkManager = nil
        try super.tearDownWithError()
    }

    func testNetworkSuccess() {
        let expectation = XCTestExpectation(description: "Successful return with data")
        var domainData: DomainSearchRecommendedResponse?
        
        self.networkManager.requestData(request: NetworkRequests.searchSuggestion("Hello").request) { (result:Result<DomainSearchRecommendedResponse, Error>) in
            switch result {
            case .success(let suggestion):
                expectation.fulfill()
                domainData = suggestion
            case .failure:
                XCTFail()
            }
        }
        wait(for: [expectation], timeout: 3.0)

        XCTAssertEqual(domainData?.products.count, 13)
        XCTAssertEqual(domainData?.products.first?.productId, 101)
        XCTAssertEqual(domainData?.products.first?.priceInfo.currentPriceDisplay, "$11.99")
        
    }
    
    func testNetworkFail() {
        let expectation = XCTestExpectation(description: "Failure return with data")
        var error: NetworkError?
        
        self.networkManager.requestData(request: NetworkRequests.searchExact("hello").request) { (result:Result<DomainSearchRecommendedResponse, Error>) in
            switch result {
            case .success:
                XCTFail()
            case .failure(let err):
                expectation.fulfill()
                error = err as? NetworkError
            }
        }
        wait(for: [expectation], timeout: 3.0)
        
        XCTAssertEqual(error, NetworkError.badData)

        
    }

}
