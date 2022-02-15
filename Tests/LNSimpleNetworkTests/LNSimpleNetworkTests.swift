
import XCTest
import Combine
@testable import LNSimpleNetwork

final class LNSimpleNetworkTests: XCTestCase {
    
    private var cancellables: Set<AnyCancellable> = []
    
    @available (iOS 15, *)
    func testSuccessAsyncAwaitWithAuthConnection() async throws {
        let loginEndpoint = Endpoint.login(userName: "kminchelle", password: "0lelplR")
        let token: Token = try await Client().connect(with: loginEndpoint)
        
        let authedEmployeeEndpoint = Endpoint.testAuthed(token: token.token)
        let employee: Employee = try await Client().connect(with: authedEmployeeEndpoint)
        XCTAssertEqual(employee.id, 1)
    }
    
    @available (iOS 15, *)
    func testSuccessAsyncAwaitConnection() async throws {
        let endpoint = Endpoint.test
        let client = Client()
        let employee: Employee = try await client.connect(with: endpoint)
        XCTAssertEqual(employee.id, 1)
    }
    
    @available (iOS 15, *)
    func testWrongMethodAsyncAwaitConnection() async throws {
        let endpoint = WhongMethodEndpoint.test
        let client = Client()
        do {
            let employee: Employee = try await client.connect(with: endpoint)
            XCTAssertNotEqual(employee.id, 1)
        } catch LNSimpleNetworkError.badResponse(let code, _) {
            XCTAssertEqual(code, 404)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testSuccessCombineConnection() throws {
        let endpoint = Endpoint.test
        let client = Client()
        
        let expectation = self.expectation(description: "Employee")
        var error: Error?
        var employee: Employee?
        
        client.connection(with: endpoint)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let returnedError):
                    error = returnedError
                }
                
                expectation.fulfill()
                
            } receiveValue: { (value: Employee) in
                employee = value
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 15)

        XCTAssertNil(error)
        XCTAssertEqual(employee?.id, 1)
    }
}

// MARK: - Models

struct Employee: Decodable {
    let id: Int
    let title: String
}

struct Token: Decodable {
    let id: Int
    let token: String
}

// MARK: - Client

struct Client: LNAPIClient {
    private (set) var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}

// MARK: - Endpoints

enum Endpoint: LNEndpoint {
    case test
    case testAuthed(token: String)
    case login(userName: String, password: String)
    
    var baseURL: String { "https://dummyjson.com" }
    var path: String {
        switch self {
        case .test: return "/products/1"
        case .testAuthed(_): return "/products/1"
        case .login(_, _): return "/auth/login"
        }
    }
    var httpMethod: LNHTTPMethod {
        switch self {
        case .test: return .get
        case .testAuthed(_): return .get
        case .login(_, _): return .post
        }
    }
    var urlParameters: [URLQueryItem] { [] }
    var body: Data? {
        switch self {
        case .test: return nil
        case .testAuthed(_): return nil
        case .login(let userName, let password):
            let parameters: [String: Any?] = [
                "username" : userName,
                "password" : password
            ]
            
            guard JSONSerialization.isValidJSONObject(parameters) else { return nil }
            
            do {
                let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
                return postData
                
            } catch(let error) {
                debugPrint(error.localizedDescription)
                return nil
            }
        }
    }
    var token: String? {
        switch self {
        case .testAuthed(let token): return token
        default: return nil
        }
    }
}

enum WhongMethodEndpoint: LNEndpoint {
    case test
    
    var baseURL: String { "https://dummyjson.com" }
    var path: String { "/products/1" }
    var httpMethod: LNHTTPMethod { .post }
    var urlParameters: [URLQueryItem] { [] }
    var body: Data? { nil }
    var token: String? { nil }
}

extension Dictionary {
    func json() -> Data? {
        guard JSONSerialization.isValidJSONObject(self) else { return nil }
        
        do {
            let postData = try JSONSerialization.data(withJSONObject: self, options: [])
            return postData
            
        } catch(let error) {
            debugPrint(error.localizedDescription)
            return nil
        }
    }
}
