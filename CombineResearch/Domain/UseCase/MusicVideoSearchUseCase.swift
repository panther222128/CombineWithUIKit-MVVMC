//
//  MainUseCase.swift
//  CombineResearch
//
//  Created by Horus on 2022/12/26.
//

import Combine

protocol MusicVideoSearchUseCase {
    func execute(requestValue: SearchMusicVideoUseCaseRequestValue) throws -> AnyPublisher<MusicVideos, Error>
    func execute(requestValue: SearchMusicVideoUseCaseRequestValue) async throws -> Result<MusicVideos, Error>
}

final class DefaultMusicVideoSearchUseCase: MusicVideoSearchUseCase {
    
    private let musicVideoSearchRepository: MusicVideoSearchRepository
    
    init(musicVideoSearchRepository: MusicVideoSearchRepository) {
        self.musicVideoSearchRepository = musicVideoSearchRepository
    }
    
    func execute(requestValue: SearchMusicVideoUseCaseRequestValue) throws -> AnyPublisher<MusicVideos, Error> {
        do {
            return try musicVideoSearchRepository.fetchMusicVideos(query: requestValue.query, limit: requestValue.limit, offset: requestValue.offset, entity: requestValue.entity)
                .eraseToAnyPublisher()
        } catch let error {
            throw error
        }
    }
    
    func execute(requestValue: SearchMusicVideoUseCaseRequestValue) async throws -> Result<MusicVideos, Error> {
        let result = try await musicVideoSearchRepository.fetchMusicVideos(query: requestValue.query, limit: requestValue.limit, offset: requestValue.offset, entity: requestValue.entity)
        return result
    }
    
}

struct SearchMusicVideoUseCaseRequestValue {
    let query: MusicVideoQuery
    let limit: Int
    let offset: Int
    let entity: String
}
