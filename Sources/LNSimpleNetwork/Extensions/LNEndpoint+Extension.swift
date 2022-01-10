//
//  LNEndpoint+Extension.swift
//
//  Created by Luciano Nunes on 10/01/22.
//

import Foundation

extension LNEndpoint {
    
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
        request.timeoutInterval = 60
        request.cachePolicy = .useProtocolCachePolicy
        
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.setValue("no-cache", forHTTPHeaderField: "cache-control")
        }
        
        return request
    }
}
