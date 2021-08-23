//
//  NetworkError.swift
//  NameSearch
//
//  Created by Marcus Washington on 8/22/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

import Foundation

enum NetworkError: Error, Equatable {
    case badRequest
    case badStatusCode(Int)
    case badData
}

extension NetworkError: LocalizedError {
        
    public var errorDescription: String? {
        switch self {
        case .badRequest:
            return NSLocalizedString("Bad URLRequest, could not convert to a URLRequest", comment: "Bad URL")
        case .badData:
            return NSLocalizedString("Bad data, the data was corrupted or incorrect", comment: "Bad data")
        case .badStatusCode(let code):
            return NSLocalizedString("The network connection was improper. Received Status code \(code)", comment: "Bad Status Code")
        }
    }
    
}
