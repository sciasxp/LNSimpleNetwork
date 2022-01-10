//
//  LNEndpoint.swift
//  
//
//  Created by Luciano Nunes on 10/01/22.
//

import Foundation

public protocol LNEndpoint {
    
    var baseURL: String { get }
    var path: String { get }
    var httpMethod: LNHTTPMethod { get }
    var urlParameters: [URLQueryItem] { get }
    var body: Data? { get }
    var token: String? { get }
}
