//
//  DataTransferService.swift
//  CombineResearch
//
//  Created by Horus on 2022/12/26.
//

import Foundation
import Combine

enum DataTransferError: String, Error {
    case request
    case noResponse
}

protocol DataTransferService {
    func request<T: Decodable, E: Requestable>(with endpoint: E) throws -> AnyPublisher<T, Error> where E.Response == T 
}

final class DefaultDataTransferService: DataTransferService {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func request<T: Decodable, E: Requestable>(with endpoint: E) throws -> AnyPublisher<T, Error> where E.Response == T {
        do {
            return try networkService.request(endpoint: endpoint)
                .decode(type: T.self, decoder: endpoint.responseDecoder)
                .eraseToAnyPublisher()
        } catch {
            throw DataTransferError.request
        }
    }
    
}
