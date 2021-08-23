//
//  Session.swift
//  NameSearch
//
//  Created by Marcus Washington on 8/22/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

import Foundation

protocol Session {
    func fetchData(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void)
}

extension URLSession: Session {
    
    func fetchData(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        self.dataTask(with: request) { data, response, error in
            completion(data, response, error)
        }.resume()
    }
    
    
}
