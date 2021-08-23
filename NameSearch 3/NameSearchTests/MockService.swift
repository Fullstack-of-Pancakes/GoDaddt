//
//  MockService.swift
//  NameSearchTests
//
//  Created by Marcus Washington on 8/22/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

import Foundation
@testable import NameSearch

class MockService: NetworkService {
    
    func requestData<T: Decodable>(request: URLRequest?, completion: @escaping (Result<T, Error>) -> Void) {
        
        let error = NSError(domain: "Generic", code: 1, userInfo: nil)
        
        guard let urlStr = request?.url?.absoluteString else {
            completion(.failure(error))
            return
        }
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            switch urlStr {
            case urlStr where urlStr == NetworkConstants.login:
                guard let loginResponse = LoginResponse(auth: Auth(token: "abcdefg"), user: User(first: "John", last: "Johnson")) as? T else {
                    completion(.failure(error))
                    return
                }
                completion(.success(loginResponse))
            default:
                completion(.failure(error))
            }
        }
        
        
    }

}
