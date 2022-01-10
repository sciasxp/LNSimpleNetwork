//
//  LNSimpleNetworkError.swift
//  
//
//  Created by Luciano Nunes on 10/01/22.
//

import Foundation

enum LNSimpleNetworkError: Error {
    case badResponse(Int)
    case jsonDecoder(String)
    case unknown, noInternet, badCredentials, badRequest
}
