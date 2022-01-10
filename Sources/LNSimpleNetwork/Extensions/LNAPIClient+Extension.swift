//
//  LNAPIClient+Extension.swift
//
//
//  Created by Luciano Nunes on 10/01/22.
//

import Foundation

extension LNAPIClient {
    
    var session: URLSession {
        return URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    }
    
    func connect<T: Decodable>(with endpoint: LNEndpoint) async throws -> T {
        guard var request = endpoint.request else {
            throw LNSimpleNetworkError.badRequest
        }
        
        if endpoint.body != nil {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        let (data, response) = try await session.data(for: request, delegate: nil)
        
        guard let response = response as? HTTPURLResponse else {
            throw LNSimpleNetworkError.badResponse(0)
        }
        
        guard 200..<300 ~= response.statusCode else {
            throw LNSimpleNetworkError.badResponse(response.statusCode)
        }
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            let responseString = String(decoding: data, as: UTF8.self)
            throw LNSimpleNetworkError.jsonDecoder(responseString)
        }
    }
}
