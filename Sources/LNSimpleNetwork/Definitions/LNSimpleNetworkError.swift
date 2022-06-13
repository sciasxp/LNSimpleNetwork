//
//  LNSimpleNetworkError.swift
//  
//
//  Created by Luciano Nunes on 10/01/22.
//

import Foundation

public enum LNSimpleNetworkError: LocalizedError {
    case badResponse(Int, Data? = nil)
    case jsonDecoder(String)
    case unknown, noInternet, badCredentials, badRequest
    
    public var errorDescription: String? {
        switch self {
        case .badResponse(let code, _):
            return "Received invalid response from server.\nCode \(code)"
        case .jsonDecoder(_):
            return "Response from server is in an invalid format."
        case .unknown:
            return "An unknown error has occured."
        case .noInternet:
            return "It was not possible to connect to the internet."
        case .badCredentials:
            return "It was not possible to authenticate with the server."
        case .badRequest:
            return "Bad request."
        }
    }
    
    public var failureReason: String? {
        switch self {
        case .badResponse(_, _):
            return "Request might have invalid data or server could not be rechead in time."
        case .jsonDecoder(_):
            return "Server sent informatation in an invalid format."
        case .unknown:
            return ""
        case .noInternet:
            return "Internet might not be reacheble at the moment."
        case .badCredentials:
            return "Your credentials with the server might have expired."
        case .badRequest:
            return "This might be an error in the app."
        }
    }
    
    public var recoverySuggestion: String? {
        switch self {
        case .badResponse(_, _):
            return "Try again later."
        case .jsonDecoder(_):
            return "Please contact app owner to inform of this problem."
        case .unknown:
            return ""
        case .noInternet:
            return "Check if your device is connected to the internet and try again."
        case .badCredentials:
            return "Try to login again."
        case .badRequest:
            return "Plese contact app owner to inform of this problem."
        }
    }
}
