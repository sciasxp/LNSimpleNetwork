import Foundation

class Client: NSObject, LNAPIClient {
    private (set) var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}

public struct LNSimpleNetwork {
    public init() {
    }
    
    public func connect<T: Decodable>(endpoint: LNEndpoint) async throws -> T {
        return try await Client().connect(with: endpoint)
    }
}
