//
//  NetworkService.swift
//  CombineResearch
//
//  Created by Horus on 2022/12/26.
//

import Foundation
import Combine

enum NetworkError: Error {
    case error(statusCode: Int, data: Data?)
    case notConnected
    case cancelled
    case generic(Error)
    case urlGeneration
    case httpURLResponse
}

protocol NetworkService {
    func request(endpoint: some Requestable) throws -> AnyPublisher<Data, Error>
}

final class DefaultNetworkService: NetworkService {
    
    private let configuration: NetworkConfigurable
    private let networkSessionManager: NetworkSessionManager
    
    init(configuration: NetworkConfigurable) {
        self.configuration = configuration
        self.networkSessionManager = DefaultNetworkSessionManager()
    }
    
    func request(endpoint: some Requestable) throws -> AnyPublisher<Data, Error> {
        do {
            let urlRequest = try endpoint.urlRequest(with: configuration)
            return try networkSessionManager.request(urlRequest)
                .tryMap() { data, response in
                    guard let httpResponse = response as? HTTPURLResponse else { throw NetworkError.httpURLResponse }
                    if httpResponse.statusCode != 200 {
                        throw NetworkError.error(statusCode: httpResponse.statusCode, data: data)
                    }
                    return data
                }
                .eraseToAnyPublisher()
            
        } catch {
            throw NetworkError.urlGeneration
        }
    }
    
}

protocol NetworkSessionManager {
    func request(_ request: URLRequest) throws -> URLSession.DataTaskPublisher
}

final class DefaultNetworkSessionManager: NetworkSessionManager {
    
    init() {
        
    }
    
    func request(_ request: URLRequest) throws -> URLSession.DataTaskPublisher {
        guard let url = request.url else { throw NetworkError.urlGeneration }
        return URLSession.shared.dataTaskPublisher(for: url)
    }
    
}
