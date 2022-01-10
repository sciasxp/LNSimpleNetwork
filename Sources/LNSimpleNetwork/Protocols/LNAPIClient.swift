//
//  LNAPIClient.swift
//  
//
//  Created by Luciano Nunes on 10/01/22.
//

import Foundation

public protocol LNAPIClient: URLSessionTaskDelegate {
    
    var decoder: JSONDecoder { get }
    var session: URLSession { get }
    
    func connect<T: Decodable>(with endpoint: LNEndpoint) async throws -> T
    
    /*
    func getData<T: Decodable>(with endpoint: Endpoint, completion: @escaping (Either<T>) -> Void)
    func sendData<T: Decodable> (with endpoint: Endpoint, method: HTTPMethod, completion: @escaping (Either<T>) -> Void)
    func patchData<T: Decodable> (with endpoint: Endpoint, completion: @escaping (Either<T>) -> Void)
    func putData<T: Decodable> (with endpoint: Endpoint, completion: @escaping (Either<T>) -> Void)
    func postData<T: Decodable> (with endpoint: Endpoint, completion: @escaping (Either<T>) -> Void)
    func postDataWithFile<T: Decodable> (with endpoint: Endpoint, fieldName: String, fileName: String, mimetype: String,
                                         completion: @escaping (Either<T>) -> Void)
    func cancelAllTasks()
    */
}
