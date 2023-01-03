//
//  MainUseCase.swift
//  CombineResearch
//
//  Created by Horus on 2022/12/26.
//

import Foundation
import Combine

enum MainUseCaseError: String, Error {
    case execute
}

protocol MusicVideoSearchUseCase {
    func execute(requestValue: SearchMusicVideoUseCaseRequestValue) throws -> AnyPublisher<MusicVideos, Error>
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
        } catch {
            throw MainUseCaseError.execute
        }
    }
    
}

struct SearchMusicVideoUseCaseRequestValue {
    let query: MusicVideoQuery
    let limit: Int
    let offset: Int
    let entity: String
}
