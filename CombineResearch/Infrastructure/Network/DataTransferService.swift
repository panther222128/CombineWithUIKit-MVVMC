//
//  DataTransferService.swift
//  CombineResearch
//
//  Created by Horus on 2022/12/26.
//

import Combine
import Foundation

enum DataTransferError: Error {
    case noResponse
    case decode
}

protocol DataTransferService {
    func request<T: Decodable, E: Requestable>(with endpoint: E) throws -> AnyPublisher<T, Error> where E.Response == T
    func request<T: Decodable, E: Requestable>(with endpoint: E) async throws -> Result<T, Error> where E.Response == T
    func request(urlString: String) async throws -> Result<Data, Error>
    func request(urlString: String, completion: @escaping (Result<Data?, Error>) -> Void)
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
                    return error
                })
                .eraseToAnyPublisher()
        } catch {
            throw DataTransferError.noResponse
        }
    }
    
    func request<T: Decodable, E: Requestable>(with endpoint: E) async throws -> Result<T, Error> where E.Response == T {
        let requestResult = await networkService.request(endpoint: endpoint)
        switch requestResult {
        case .success(let data):
            do {
                let decoded = try endpoint.responseDecoder.decode(T.self, from: data)
                let success: Result<T, Error> = .success(decoded)
                return success
            } catch {
                let decodeFail: Result<T, Error> = .failure(DataTransferError.decode)
                return decodeFail
            }
            
        case .failure(let error):
            throw error
            
        }
    }
    
    func request(urlString: String) async throws -> Result<Data, Error> {
        let requestResult = await networkService.request(urlString: urlString)
        switch requestResult {
        case .success(let data):
            let success: Result<Data, Error> = .success(data)
            return success
            
        case .failure(let error):
            throw error
            
        }
    }
    
    func request(urlString: String, completion: @escaping (Result<Data?, Error>) -> Void) {
        networkService.request(urlString: urlString) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async { completion(.success(data)) }
                
            case .failure(let error):
                DispatchQueue.main.async { completion(.failure(error)) }
                
            }
        }
    }
    
}
