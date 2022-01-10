import XCTest
@testable import LNSimpleNetwork

final class LNSimpleNetworkTests: XCTestCase {
    func testExample() throws {
        let endpoint = Endpoint.test
        let client = LNSimpleNetwork()
        Task {
            let employee: Employee = try await client.connect(endpoint: endpoint)
            XCTAssertEqual(employee.id, 1)
        }
    }
}

struct Employee: Decodable {
    let id: Int
    let title: String
}

enum Endpoint: LNEndpoint {
    case test
    
    var baseURL: String {
        "https://dummyjson.com"
    }
    
    var path: String {
        "/products/1"
    }
    
    var httpMethod: LNHTTPMethod {
        .get
    }
    
    var urlParameters: [URLQueryItem] {
        []
    }
    
    var body: Data? {
        nil
    }
    
    var token: String? {
        nil
    }
}
