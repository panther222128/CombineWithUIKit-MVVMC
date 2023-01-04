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
    case session
}

protocol NetworkService {
    func request(endpoint: any Requestable) throws -> AnyPublisher<Data, Error>
}

final class DefaultNetworkService: NetworkService {
    
    private let configuration: NetworkConfigurable
    private let networkSessionManager: NetworkSessionManager
    
    init(configuration: NetworkConfigurable) {
        self.configuration = configuration
        self.networkSessionManager = DefaultNetworkSessionManager()
    }
    
    func request(endpoint: any Requestable) throws -> AnyPublisher<Data, Error> {
        do {
            let urlRequest = try endpoint.urlRequest(with: configuration)
            return try networkSessionManager.request(urlRequest)
                .tryMap() { data, response in
                    return data
                }
                .eraseToAnyPublisher()
            
        } catch {
            throw NetworkError.session
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
        guard let url = request.url else { throw NetworkError.session }
        return URLSession.shared.dataTaskPublisher(for: url)
    }
    
}
