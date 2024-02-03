//
//  MainRepository.swift
//  CombineResearch
//
//  Created by Horus on 2022/12/26.
//

import Combine

protocol MusicVideoSearchRepository {
    func fetchMusicVideos(query: MusicVideoQuery, limit: Int, offset: Int, entity: String) throws -> AnyPublisher<MusicVideos, Error>
    func fetchMusicVideos(query: MusicVideoQuery, limit: Int, offset: Int, entity: String) async throws -> Result<MusicVideos, Error>
}
