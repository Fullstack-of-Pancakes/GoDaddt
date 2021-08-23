//
//  NetworkRequests.swift
//  NameSearch
//
//  Created by Marcus Washington on 8/22/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

import Foundation

struct NetworkConstants {
    static let login = "https://gd.proxied.io/auth/login"
    static let searchExact = "https://gd.proxied.io/search/exact"
    static let searchSuggestion = "https://gd.proxied.io/search/spins"
}


enum NetworkRequests {
    
    private enum RequestType: String {
        case get = "GET"
        case post = "POST"
    }
    
    case login([String: String])
    case searchExact(String)
    case searchSuggestion(String)
    
    var request: URLRequest? {
        var _request: URLRequest?
        
        switch self {
        case .login(let credentials):
            guard let url = URL(string: NetworkConstants.login) else { return nil }
            _request = URLRequest(url: url)
            _request?.httpMethod = RequestType.post.rawValue
            _request?.httpBody = try? JSONSerialization.data(withJSONObject: credentials, options: .fragmentsAllowed)
        case .searchExact(let query):
            var components = URLComponents(string: NetworkConstants.searchExact)
            components?.queryItems = [URLQueryItem(name: "q", value: query)]
            guard let url = components?.url else { return nil }
            _request = URLRequest(url: url)
            _request?.httpMethod = RequestType.get.rawValue
        case .searchSuggestion(let query):
            var components = URLComponents(string: NetworkConstants.searchSuggestion)
            components?.queryItems = [URLQueryItem(name: "q", value: query)]
            guard let url = components?.url else { return nil }
            _request = URLRequest(url: url)
            _request?.httpMethod = RequestType.get.rawValue
        }
        
        return _request
    }
    
}
