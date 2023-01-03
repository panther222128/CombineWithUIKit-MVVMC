//
//  NetworkService.swift
//  CombineResearch
//
//  Created by Horus on 2022/12/26.
//

import Foundation
import Combine

enum NetworkSessionError: String, Error {
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
                .mapError() { error in
                    return error
                }
                .eraseToAnyPublisher()
            
        } catch {
            throw NetworkSessionError.session
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
        guard let url = request.url else { throw NetworkSessionError.session }
        return URLSession.shared.dataTaskPublisher(for: url)
    }
    
}
