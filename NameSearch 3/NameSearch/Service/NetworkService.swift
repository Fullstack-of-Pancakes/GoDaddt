//
//  NetworkManager.swift
//  NameSearch
//
//  Created by Marcus Washington on 8/22/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

import Foundation

protocol NetworkService {
    func requestData<T: Decodable>(request: URLRequest?, completion: @escaping (Result<T, Error>) -> Void)
}

class NetworkManager {
    
    let session: Session
    
    init(session: Session = URLSession.shared) {
        self.session = session
    }
    
}

extension NetworkManager: NetworkService {
    
    func requestData<T: Decodable>(request: URLRequest?, completion: @escaping (Result<T, Error>) -> Void) {
        
        
        guard let request = request else {
            completion(.failure(NetworkError.badRequest))
            return
        }
        
        
        self.session.fetchData(request: request) { data, response, error in
            
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, !(200..<300).contains(httpResponse.statusCode) {
                completion(.failure(NetworkError.badStatusCode(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.badData))
                return
            }
            
            do {
                let model = try JSONDecoder().decode(T.self, from: data)
                completion(.success(model))
            } catch {
                completion(.failure(error))
            }
            
        }
        
    }
    
}
