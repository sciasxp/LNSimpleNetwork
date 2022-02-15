# LNSimpleNetwork 🪛



A simple tool to organize yours rest apis connection and use then.

This code is implemented to make use of either async/await or combine framework.

## Minimum Requirements

This framework will be usable by iOS 13 and above or MacOS 10.15 and above.

For versions bellow iOS 15 or MacOS 12 it will only be possible to use the combine methods. 

## Installing

**LNSimpleNetwork is available via SwiftPackage.**

Add the following to you Package.swift file's dependencies:

```swift
.package(url: "https://github.com/sciasxp/LNSimpleNetwork.git", from: "0.1.0"),
```

## How to Use

LNSimpleNetwork consists of two protocols that you should implement.

### LNAPIClient

This one will be responsible for the network part connecting to your API.

```swift
struct Client: LNAPIClient {}
```

You can customize this struct in two ways:
1. Implementing a custom decoder:
```swift
struct Client: LNAPIClient {
    private(set) var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}
```
You can implement more de one client for different decodign needs.

2. Implementing a custom Session:
```swift
struct Client: LNAPIClient {
    private(set) var session: URLSession {
        return URLSession(configuration: .default, delegate: nil, delegateQueue: nil)
    }
}
```

### LNEndpoint

This one is responsible for organize the route api paths and parameters.

```swift
enum Endpoint: LNEndpoint {
    case test
    
    var baseURL: String { "https://dummyjson.com" }
    var path: String { "/products/1" }
    var httpMethod: LNHTTPMethod { .get }
    var urlParameters: [URLQueryItem] { [] }
    var body: Data? { nil }
    var token: String? { nil }
}
```

For each route you have you should implement different case for the enum.

For the above exemple we have only one route, **case test**, and it's configurations are described by de following computed variables:

**baseURL: String**
This one will return the domain for your API. Usually it will have only one value but you can use diffent domains depending on your enviroment.
```swift
var baseURL: String {
    if GlobalConstants.isDebug {
        return "https://qa.dummyjson.com"
    } else {
        return "https://dummyjson.com"
    }
}
```

**path: String**
This one will discribe the path for each of the cases you defined.
In our exemple we have only um route in this API so you can return only one value but if you have two or more case you can use a switch-case to respond to the path.
```swift
var path: String {
    switch self {
        case .products: return "/products"
        case .charts: return "/charts" 
    }
}
```

Now, what if you have different paths for your products?
/products/1
/products/2

Those are neither parameters nor body of you request so it should be encoded in your url. For this you should pass the variable in yours case statement and the use it in the switch-case as shown below:
```swift
enum Endpoint: LNEndpoint {
    case product(code: Int)
    
    var baseURL: String { "https://dummyjson.com" }
    var path: String {
        switch self {
            case .product(let code): return "/products/\(code)"
        } 
    }
    var httpMethod: LNHTTPMethod { .get }
    var urlParameters: [URLQueryItem] { [] }
    var body: Data? { nil }
    var token: String? { nil }
}
```

The same logic applies to the other properties.

**httpMethod: LNHTTPMethod**
This will be responsible to inform which method your request should be using.
Those methods are defined in the LNHTTPMethod enum:
```switch
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
```

**urlParameters: [URLQueryItem]**
If your route have to pass some parameters, normally on a get request, you will need return those parameters in the forma of an array of URLQueryItem.
```swift
var urlParameters: [URLQueryItem] {
    switch self {
    case .info(let version):
        return [
            URLQueryItem(name: "version", value: version)
        ]
            
    default:
        return []
    }
}
```

In the above exemple only info route have to pass a parameter. The others routes don't have a need to do so, for these routes we pass an empty array at the switch default value.

**body: Data?**
Here you will pass any configurations encoded to the resquest's body. This one should retourn an JSON enconded body.
```swift
var body: Data? = {
    switch self {
        case .login(let username, let password):
            let bodyDictionary: [String: Any?] = [
                "username": username,
                "password": password
            ]
            
            guard JSONSerialization.isValidJSONObject(bodyDictionary) else { return nil }
            
            do {
                let postData = try JSONSerialization.data(withJSONObject: bodyDictionary, options: [])
                return postData
                
            } catch(let error) {
                debugPrint(error.localizedDescription)
                return nil
            }
            
        default: return nil
    }
}
```

In this case you can simplify the json conversion with the following snipt:
```swift
extension Dictionary {
    /**
     Returns an JSON object.
     
     - returns: If the dictionary conforms to a JSON returns a JSON object.
                In case the dictionary iso not a vlid JSON representation, returns nil.
    */
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
```

With this, our previous exemple should become more simpler:
```swift
var body: Data? = {
    switch self {
        case .login(let username, let password):
            let bodyDictionary: [String: Any?] = [
                "username": username,
                "password": password
            ]
            
            return bodyDictionary.json()
            
        default: return nil
    }
}
```

**token: String?**
This will only be used in the case of athenticated route. For security reasons I recomend to pass the token as a property of its route enum and neve hard code it.
```swift
enum Endpoint: LNEndpoint {
    case product(token: String)
    
    var baseURL: String { "https://dummyjson.com" }
    var path: String { "/products/1" }
    var httpMethod: LNHTTPMethod { .get }
    var urlParameters: [URLQueryItem] { [] }
    var body: Data? { nil }
    var token: String? { 
        switch self {
            case .product(let token): return token
        }
    }
}
```

### Complete Exemple of LNAPIClient and LNEndpoint

```swift
struct Client: LNAPIClient {
    private (set) var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}

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
```

### When Everything is Done

Now that we have ours client and endpoint implemented the usage become fairly simple.

There is two ways to use it:

**The Combine Way**
```swift
struct User: Decodable {
    let id: Int
    let token: String
}

var cancellables: Set<AnyCancellable> = []

var user: User?

func test() {
    let endpoint = Endpoint.login(userName: "teste", password: "teste")
    let client = Client()
    client.connection(with: endpoint)
        .sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let returnedError):
                error = returnedError
            }
        } receiveValue: { (value: User) in
            user = value
        }
        .store(in: &cancellables)
}
```

**The Async/Await Way**
```swift
struct User: Decodable {
    let id: Int
    let token: String
}

func test() async throws {
    let loginEndpoint = Endpoint.login(userName: "teste", password: "teste")
    let user: User = try await Client().connect(with: loginEndpoint)
}
```

## Future Work

1. Support to download files.
2. Improved implementation to LNEndpoint Protocol Extension.
3. Review documentation.
4. Make it a cocoapod.
5. Improve unit tests.

## Contributing

You are most welcome in contributing to this project with either new features (maybe one mentioned from the future work or anything else), refactoring and improving the code. Also, feel free to give suggestions and feedbacks. 

Created with ❤️ by Luciano Nunes.

Get in touch on [Email](mailto: sciasxp@gmail.com)
Visit:  [LinkdIn](https://www.linkedin.com/in/lucianonunesdev/)
