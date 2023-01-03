//
//  MainRepository.swift
//  CombineResearch
//
//  Created by Horus on 2022/12/26.
//

import Foundation
import Combine

protocol MusicVideoSearchRepository {
    func fetchMusicVideos(query: MusicVideoQuery, limit: Int, offset: Int, entity: String) throws -> AnyPublisher<MusicVideos, Error>
}
