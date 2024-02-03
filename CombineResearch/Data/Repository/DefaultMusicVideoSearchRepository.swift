//
//  DefaultMainRepository.swift
//  CombineResearch
//
//  Created by Horus on 2022/12/26.
//

import Combine

final class DefaultMusicVideoSearchRepository: MusicVideoSearchRepository {
    
    private let dataTransferService: DataTransferService
    
    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
    
    func fetchMusicVideos(query: MusicVideoQuery, limit: Int, offset: Int, entity: String) throws -> AnyPublisher<MusicVideos, Error> {
        let requestDTO = MusicVideoRequestDTO(term: query.query, limit: limit, offset: offset, entity: entity)
        let endpoint = APIEndpoints.getMusicVideo(with: requestDTO)
        do {
            return try dataTransferService.request(with: endpoint)
                .tryMap() { data in
                    return data.toDomain()
                }
                .eraseToAnyPublisher()
        } catch let error {
            throw error
        }
    }
    
    func fetchMusicVideos(query: MusicVideoQuery, limit: Int, offset: Int, entity: String) async throws -> Result<MusicVideos, Error> {
        let requestDTO = MusicVideoRequestDTO(term: query.query, limit: limit, offset: offset, entity: entity)
        let endpoint = APIEndpoints.getMusicVideo(with: requestDTO)
        let result = try await dataTransferService.request(with: endpoint)
        switch result {
        case .success(let data):
            let domain = data.toDomain()
            let success: Result<MusicVideos, Error> = .success(domain)
            return success
            
        case .failure(let error):
            let failure: Result<MusicVideos, Error> = .failure(error)
            return failure
            
        }
    }
    
}
