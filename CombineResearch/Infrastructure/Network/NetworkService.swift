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
    case request
}

protocol NetworkService {
    func request(endpoint: some Requestable) throws -> AnyPublisher<Data, Error>
    func request(endpoint: some Requestable) async -> Result<Data, NetworkError>
    func request(urlString: String) async -> Result<Data, NetworkError>
    func request(urlString: String, completion: @escaping ((Result<Data?, NetworkError>) -> Void))
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

    func request(endpoint: some Requestable) async -> Result<Data, NetworkError> {
        do {
            let urlRequest = try endpoint.urlRequest(with: configuration)
            let result = try await networkSessionManager.request(urlRequest)
            switch result {
            case .success(let (data, response)):
                if let httpResponse = response as? HTTPURLResponse {
                    if (200..<300).contains(httpResponse.statusCode) {
                        let success: Result<Data, NetworkError> = .success(data)
                        return success
                    } else {
                        let statucCodeFailure: Result<Data, NetworkError> = .failure(.error(statusCode: httpResponse.statusCode, data: data))
                        return statucCodeFailure
                    }
                } else {
                    let failure: Result<Data, NetworkError> = .failure(.httpURLResponse)
                    return failure
                }
                
            case .failure(let error):
                let failure: Result<Data, NetworkError> = .failure(error)
                return failure
                
            }
        } catch {
            let failure: Result<Data, NetworkError> = .failure(.request)
            return failure
        }
    }
    
    
    
    func request(urlString: String) async -> Result<Data, NetworkError> {
        if let url = URL(string: urlString) {
            let urlRequest = URLRequest(url: url)
            do {
                let result = try await networkSessionManager.request(urlRequest)
                switch result {
                case .success(let (data, response)):
                    if let httpResponse = response as? HTTPURLResponse {
                        if (200..<300).contains(httpResponse.statusCode) {
                            let success: Result<Data, NetworkError> = .success(data)
                            return success
                        } else {
                            let statucCodeFailure: Result<Data, NetworkError> = .failure(.error(statusCode: httpResponse.statusCode, data: data))
                            return statucCodeFailure
                        }
                    } else {
                        let failure: Result<Data, NetworkError> = .failure(.httpURLResponse)
                        return failure
                    }
                    
                case .failure(let error):
                    let failure: Result<Data, NetworkError> = .failure(error)
                    return failure
                    
                }
            } catch {
                let failure: Result<Data, NetworkError> = .failure(.request)
                return failure
            }
        } else {
            let urlFailure: Result<Data, NetworkError> = .failure(.urlGeneration)
            return urlFailure
        }
        
    }
    
    func request(urlString: String, completion: @escaping ((Result<Data?, NetworkError>) -> Void)) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            let task = networkSessionManager.request(request) { data, response, requestError in
                if let requestError = requestError {
                    var error: NetworkError
                    if let response = response as? HTTPURLResponse {
                        error = .error(statusCode: response.statusCode, data: data)
                    } else {
                        error = self.resolve(error: requestError)
                    }
                    completion(.failure(error))
                    
                } else {
                    completion(.success(data))
                }
            }
            task.resume()
        } else {
            completion(.failure(.urlGeneration))
        }
    }
    
    private func resolve(error: Error) -> NetworkError {
        let code = URLError.Code(rawValue: (error as NSError).code)
        switch code {
        case .notConnectedToInternet: return .notConnected
        case .cancelled: return .cancelled
        default: return .generic(error)
        }
    }
    
}

protocol NetworkSessionManager {
    func request(_ request: URLRequest) throws -> URLSession.DataTaskPublisher
    func request(_ request: URLRequest) async throws -> Result<(Data, URLResponse), NetworkError>
    func request(_ request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionTask
}

final class DefaultNetworkSessionManager: NetworkSessionManager {
    
    init() {
        
    }
    
    func request(_ request: URLRequest) throws -> URLSession.DataTaskPublisher {
        guard let url = request.url else { throw NetworkError.urlGeneration }
        return URLSession.shared.dataTaskPublisher(for: url)
    }
    
    func request(_ request: URLRequest) async throws -> Result<(Data, URLResponse), NetworkError>  {
        guard let url = request.url else {
            let failure: Result<(Data, URLResponse), NetworkError> = .failure(.urlGeneration)
            return failure
        }
        let result = try await URLSession.shared.data(from: url)
        let success: Result<(Data, URLResponse), NetworkError> = .success(result)
        return success
    }
    
    func request(_ request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionTask {
        let task = URLSession.shared.dataTask(with: request, completionHandler: completion)
        task.resume()
        return task
    }
    
}
