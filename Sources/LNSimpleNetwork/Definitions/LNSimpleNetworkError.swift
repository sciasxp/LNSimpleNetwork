//
//  LNSimpleNetworkError.swift
//  
//
//  Created by Luciano Nunes on 10/01/22.
//

import Foundation

public enum LNSimpleNetworkError: Error {
    case badResponse(Int, Data? = nil)
    case jsonDecoder(String)
    case unknown, noInternet, badCredentials, badRequest
}
