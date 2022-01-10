//
//  LNHTTPMethod.swift
//  
//
//  Created by Luciano Nunes on 10/01/22.
//

import Foundation

public enum LNHTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}
