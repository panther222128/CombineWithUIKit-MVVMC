//
//  Endpoint.swift
//  CombineResearch
//
//  Created by Horus on 2022/12/26.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum BodyEncoding {
    case jsonSerializationData
    case stringEncodingAscii
}

enum RequestGenerationError: Error {
    case components
    case url
}

protocol Requestable {
    associatedtype Response
    
    var responseDecoder: JSONDecoder { get }
    var path: String { get }
    var isFullPath: Bool { get }
    var headerParameters: [String: String] { get }
    var headerParametersEncodable: Encodable? { get }
    var queryParameters: [String: Any] { get }
    var queryParametersEncodable: Encodable? { get }
    var bodyParameters: [String: Any] { get }
    var bodyParametersEncodable: Encodable? { get }
    var method: HTTPMethod { get }
    var bodyEncoding: BodyEncoding { get }
    
    func urlRequest(with networkConfiguration: NetworkConfigurable) throws -> URLRequest
}

final class Endpoint<R>: Requestable {
    
    typealias Response = R
    
    let responseDecoder: JSONDecoder
    let path: String
    let isFullPath: Bool
    let headerParameters: [String : String]
    let headerParametersEncodable: Encodable?
    let queryParameters: [String : Any]
    let queryParametersEncodable: Encodable?
    let bodyParameters: [String : Any]
    let bodyParametersEncodable: Encodable?
    let method: HTTPMethod
    let bodyEncoding: BodyEncoding

    init(responseDecoder: JSONDecoder = JSONDecoder(), path: String, isFullPath: Bool = false, headerParameters: [String: String] = [:], headerParametersEncodable: Encodable? = nil, queryParameters: [String: Any] = [:], queryParametersEncodable: Encodable? = nil, bodyParameters: [String: Any] = [:], bodyParametersEncodable: Encodable? = nil, method: HTTPMethod, bodyEncoding: BodyEncoding = .jsonSerializationData) {
        self.responseDecoder = responseDecoder
        self.path = path
        self.isFullPath = isFullPath
        self.headerParameters = headerParameters
        self.headerParametersEncodable = headerParametersEncodable
        self.queryParameters = queryParameters
        self.queryParametersEncodable = queryParametersEncodable
        self.bodyParameters = bodyParameters
        self.bodyParametersEncodable = bodyParametersEncodable
        self.method = method
        self.bodyEncoding = bodyEncoding
    }
    
}

extension Requestable {
    
    private func url(with networkConfiguration: NetworkConfigurable) throws -> URL {
        let baseURLString = networkConfiguration.baseURL.absoluteString.last != "/" ? networkConfiguration.baseURL.absoluteString + "/" : networkConfiguration.baseURL.absoluteString
        let endpoint = isFullPath ? path : baseURLString.appending(path)
        
        guard var urlComponents = URLComponents(string: endpoint) else { throw
            RequestGenerationError.components
        }
        
        var urlQueryItems = [URLQueryItem]()
        
        let queryParameters = try queryParametersEncodable?.toDictionary() ?? self.queryParameters
        queryParameters.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
        }
        networkConfiguration.queryParameters.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: $0.value))
        }
        
        urlComponents.queryItems = !urlQueryItems.isEmpty ? urlQueryItems : nil
        guard let url = urlComponents.url else { throw
            RequestGenerationError.components
        }
        
        return url
    }
    
    func urlRequest(with networkConfiguration: NetworkConfigurable) throws -> URLRequest {
        let url = try self.url(with: networkConfiguration)
        var urlRequest = URLRequest(url: url)
        
        var headers: [String: String] = Constants.EndpointHeaders.headers
        headerParameters.forEach { headers.updateValue($1, forKey: $0) }
        
        let bodyParameters = try bodyParametersEncodable?.toDictionary() ?? self.bodyParameters
        
        if !bodyParameters.isEmpty {
            urlRequest.httpBody = encodeBody(bodyParameters: bodyParameters, bodyEncoding: bodyEncoding)
        }
        
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        
        return urlRequest
    }
    
    private func encodeBody(bodyParameters: [String: Any], bodyEncoding: BodyEncoding) -> Data? {
        switch bodyEncoding {
        case .jsonSerializationData:
            return try? JSONSerialization.data(withJSONObject: bodyParameters)
        case .stringEncodingAscii:
            return bodyParameters.queryString.data(using: String.Encoding.ascii, allowLossyConversion: true)
        }
    }
    
}
