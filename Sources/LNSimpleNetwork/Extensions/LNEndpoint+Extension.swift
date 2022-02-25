//
//  LNEndpoint+Extension.swift
//
//  Created by Luciano Nunes on 10/01/22.
//

import Foundation

public extension LNEndpoint {
    
    var urlComponent: URLComponents? {
        var urlComponent = URLComponents(string: baseURL)
        urlComponent?.path = path
        urlComponent?.queryItems = urlParameters
        
        return urlComponent
    }
    
    var request: URLRequest?  {
        guard let url = urlComponent?.url else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpBody = body
        request.timeoutInterval = 10
        request.cachePolicy = .useProtocolCachePolicy
        request.httpMethod = httpMethod.rawValue
        
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.setValue("no-cache", forHTTPHeaderField: "cache-control")
        }
        
        return request
    }
    
    var body: Data? { nil }
    var token: String? { nil }
    var httpMethod: LNHTTPMethod { .get }
    var urlParameters: [URLQueryItem] { [] }
}
