//
//  ApiManager.swift
//  Touch
//
//  Copyright (c) 2021 EngageCraft. All rights reserved.
//

import Foundation
import Network

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
    case head = "HEAD"
    case options = "OPTIONS"
    case trace = "TRACE"
    case connect = "CONNECT"
}

struct HTTPHeader {
    let field: String
    let value: String
}

// MARK: Request

class APIRequest {
    let method: HTTPMethod
    let path: String
    var queryItems: [URLQueryItem]?
    var headers: [HTTPHeader]?
    var body: Data?
    
    init(method: HTTPMethod, path: String) {
        self.method = method
        self.path = path
    }
    
    init<Body: Encodable>(method: HTTPMethod, path: String, body: Body) throws {
        self.method = method
        self.path = path
        self.body = try JSONEncoder().encode(body)
    }
}


// MARK: Errors

enum APIError: Error {
    case invalidURL
    case requestFailed
    case decodingFailure
}

// MARK: Response

struct APIResponse<Body> {
    let statusCode: Int
    let body: Body
}

extension APIResponse where Body == Data? {
    func decode<BodyType: Decodable>(to type: BodyType.Type) throws -> APIResponse<BodyType> {
        guard let data = body else {
            throw APIError.decodingFailure
        }
        let decodedJSON = try JSONDecoder().decode(BodyType.self, from: data)
        return APIResponse<BodyType>(statusCode: self.statusCode,
                                     body: decodedJSON)
    }
}

enum APIResult<Body> {
    case success(APIResponse<Body>)
    case failure(APIError)
}

// MARK: APIManager class

class APIManager{
    typealias APIClientCompletion = (APIResult<Data?>) -> Void
    
    private var baseURL = URL(string: "https://api.touch.global/api/")!
    private var session: URLSession!
    
    private var defaultHeaders:[HTTPHeader] = []
    private var environment: String = "" {
        didSet{
            baseURL = URL(string:"https://api\(environment).touch.global/api/")!
        }
    }
    
     // singleton
    static public let shared = APIManager()
    private init() {
        session = URLSession.shared
    }
    
    // Setup
    public func setup(client:String, environment: String = ""){
        self.environment = environment
        defaultHeaders = [HTTPHeader(field: "x-api-client", value: client),
                          HTTPHeader(field: "Accept", value:"application/json")]
        self.environment = environment
    }
        
    // Call
    func perform<W:Codable>(_ request: APIRequest, to type: W.Type, _ completion: @escaping (APIResult<W>) -> Void) {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = baseURL.scheme
        urlComponents.host = baseURL.host
        urlComponents.path = baseURL.path
        urlComponents.queryItems = request.queryItems
        
        guard let url = urlComponents.url?.appendingPathComponent(request.path) else {
            completion(.failure(.invalidURL)); return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body
        
        defaultHeaders.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.field) }
        request.headers?.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.field) }
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed))
                return
            }
            guard httpResponse.statusCode == 200 else{
                completion(.failure(.requestFailed))
                return
            }
            let response = APIResponse<Data?>(statusCode: httpResponse.statusCode, body: data)
            if let responseData = try? response.decode(to: type) {
                completion(.success(responseData))
            }else{
                completion(.failure(.decodingFailure))
            }
        }
        task.resume()
    }
}
