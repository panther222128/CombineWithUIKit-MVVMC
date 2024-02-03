//
//  DefaultMusicVideoImageRepository.swift
//  CombineResearch
//
//  Created by Horus on 2/2/24.
//

import Foundation

final class DefaultMusicVideoImageRepository: MusicVideoImageRepository {
    
    private let dataTransferService: DataTransferService
    
    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
    
    func fetchMusicVideoImage(with urlString: String, trackID: Int) async -> Result<Data, Error> {
        if let cachedData = CacheHandler.shared.readFromCache(with: trackID) {
            let success: Result<Data, Error> = .success(cachedData)
            return success
        } else {
            do {
                let requestResult = try await dataTransferService.request(urlString: urlString)
                switch requestResult {
                case .success(let data):
                    CacheHandler.shared.addToCache(key: trackID, data: data)
                    let cachedData = CacheHandler.shared.readFromCache(with: trackID)!
                    let success: Result<Data, Error> = .success(cachedData)
                    return success
                    
                case .failure(let error):
                    let failure: Result<Data, Error> = .failure(error)
                    return failure
                    
                }
            } catch let error {
                let failure: Result<Data, Error> = .failure(error)
                return failure
            }
        }
    }
    
    func fetchMusicVideoImage(with urlString: String, trackID: Int, completion: @escaping (Result<Data?, Error>) -> Void) {
        if let cachedData = CacheHandler.shared.readFromCache(with: trackID) {
            let success: Result<Data?, Error> = .success(cachedData)
            completion(success)
        } else {
            dataTransferService.request(urlString: urlString) { result in
                switch result {
                case .success(let data):
                    if let data = data {
                        CacheHandler.shared.addToCache(key: trackID, data: data)
                        let cachedData = CacheHandler.shared.readFromCache(with: trackID)!
                        completion(.success(cachedData))
                    } else {
                        completion(.success(nil))
                    }
                    
                case .failure(let error):
                    completion(.failure(error))
                    
                }
            }
        }
    }
    
}
