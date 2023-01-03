//
//  DefaultMainRepository.swift
//  CombineResearch
//
//  Created by Horus on 2022/12/26.
//

import Foundation
import Combine

enum MusicVideoSearchRepositoryError: String, Error {
    case request
}

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
        } catch {
            throw MusicVideoSearchRepositoryError.request
        }
    }
    
}
