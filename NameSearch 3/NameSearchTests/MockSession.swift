//
//  MockSession.swift
//  NameSearchTests
//
//  Created by Marcus Washington on 8/22/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

import Foundation
@testable import NameSearch

class MockSession: Session {
    
    func fetchData(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            if request.url?.absoluteString == "\(NetworkConstants.searchExact)?q=hello" {
                completion(nil, nil, nil)
            } else {
                let bundle = Bundle(for: NameSearchTests.self)
                guard let path = bundle.path(forResource: "DomainSampleData", ofType: "json") else {
                    completion(nil, nil, NetworkError.badRequest)
                    return
                }
                let url = URL(fileURLWithPath: path)
                do {
                    let data = try Data(contentsOf: url)
                    let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
                    completion(data, response, nil)
                } catch {
                    completion(nil, nil, error)
                }
            }
        }
        
    }
    
}
