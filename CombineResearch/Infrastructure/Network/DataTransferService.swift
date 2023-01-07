//
//  DataTransferService.swift
//  CombineResearch
//
//  Created by Horus on 2022/12/26.
//

import Combine

enum DataTransferError: Error {
    case noResponse
    case decode
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
                .mapError({ error in
                    return DataTransferError.decode
                })
                .eraseToAnyPublisher()
        } catch {
            throw DataTransferError.noResponse
        }
    }
    
}
