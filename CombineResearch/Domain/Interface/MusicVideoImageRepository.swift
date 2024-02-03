//
//  MusicVideoImageRepository.swift
//  CombineResearch
//
//  Created by Horus on 2/2/24.
//

import Foundation

protocol MusicVideoImageRepository {
    func fetchMusicVideoImage(with urlString: String, trackID: Int) async -> Result<Data, Error>
    func fetchMusicVideoImage(with urlString: String, trackID: Int, completion: @escaping (Result<Data?, Error>) -> Void)
}
