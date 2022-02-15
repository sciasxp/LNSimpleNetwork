//
//  LNAPIClient+Extension.swift
//
//
//  Created by Luciano Nunes on 10/01/22.
//

import Foundation
import Combine

@available(macOS 10.15, iOS 13.0, *)
public extension LNAPIClient {
    var session: URLSession {
        return URLSession(configuration: .default, delegate: nil, delegateQueue: nil)
    }
    
    var decoder: JSONDecoder {
        JSONDecoder()
    }
    
    func connection<T: Decodable>(with endpoint: LNEndpoint) -> AnyPublisher<T, Error> {
        guard let request = endpoint.request else {
            return Fail(error: LNSimpleNetworkError.badRequest).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: request)
            .receive(on: DispatchQueue.main)
            .tryMap(handleOutput)
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    private func handleOutput(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard let response = output.response as? HTTPURLResponse else { throw URLError(.badServerResponse) }
        
        guard 200..<300 ~= response.statusCode else {
            throw LNSimpleNetworkError.badResponse(response.statusCode, output.data)
        }
        
        return output.data
    }
    
    func cancelAllTasks() {
        session.getAllTasks { (tasks) in
            tasks.forEach { $0.cancel() }
        }
    }
}

@available(macOS 12, iOS 15, *)
public extension LNAPIClient {
    
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
        
        let sanitizedData = try handleResponse(data: data, response: response)
        
        do {
            return try decoder.decode(T.self, from: sanitizedData)
        } catch {
            let responseString = String(decoding: data, as: UTF8.self)
            throw LNSimpleNetworkError.jsonDecoder(responseString)
        }
    }
    
    private func handleResponse(data: Data?, response: HTTPURLResponse?) throws -> Data {
        guard let response = response, let data = data else { throw URLError(.badServerResponse) }
        
        guard 200..<300 ~= response.statusCode else {
            throw LNSimpleNetworkError.badResponse(response.statusCode, data)
        }
        
        return data
    }
}
