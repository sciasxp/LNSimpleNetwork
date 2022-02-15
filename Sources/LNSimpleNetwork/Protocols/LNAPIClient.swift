//
//  LNAPIClient.swift
//  
//
//  Created by Luciano Nunes on 10/01/22.
//

import Foundation
import Combine

public protocol LNAPIClient: URLSessionTaskDelegate {
    
    var decoder: JSONDecoder { get }
    var session: URLSession { get }
    func cancelAllTasks()
    
    @available(macOS 10.15, iOS 13.0, *)
    func connection<T: Decodable>(with request: URLRequest, decoder: JSONDecoder) -> AnyPublisher<T, Error>
    
    @available(macOS 12, iOS 15, *)
    func connect<T: Decodable>(with endpoint: LNEndpoint) async throws -> T
}
