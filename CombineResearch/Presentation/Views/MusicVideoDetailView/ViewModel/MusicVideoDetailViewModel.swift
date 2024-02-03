//
//  MusicVideoDetailViewModel.swift
//  CombineResearch
//
//  Created by Horus on 2023/01/04.
//

import Combine
import Foundation

protocol MusicVideoDetailViewModel {
    var artistName: String { get }
    var trackName: String { get }
    var artworkUrl100: String { get }
    var trackTimeMillis: Int? { get }
    var country: String { get }
    var primaryGenreName: String { get }
    var artworkImageData: Data? { get }
    var errorPublisher: AnyPublisher<String, Never> { get }
    
    func loadArtworkImage() async
}

final class DefaultMusicVideoDetailViewModel: MusicVideoDetailViewModel {
    
    private let musicVideoImageRepository: MusicVideoImageRepository
    
    let artistName: String
    let trackName: String
    let trackID: Int
    let artworkUrl100: String
    let trackTimeMillis: Int?
    let country: String
    let primaryGenreName: String
    private(set) var artworkImageData: Data?
    private let error: PassthroughSubject<String, Never>
    
    var errorPublisher: AnyPublisher<String, Never> {
        return error.eraseToAnyPublisher()
    }
    
    init(musicVideoImageRepository: MusicVideoImageRepository, musicVideo: MusicVideo) {
        self.musicVideoImageRepository = musicVideoImageRepository
        self.artistName = musicVideo.artistName
        self.trackName = musicVideo.trackName
        self.trackID = musicVideo.trackID
        self.artworkUrl100 = musicVideo.artworkUrl100
        self.trackTimeMillis = musicVideo.trackTimeMillis ?? nil
        self.country = musicVideo.country
        self.primaryGenreName = musicVideo.primaryGenreName
        self.artworkImageData = nil
        self.error = .init()
    }
    
    func loadArtworkImage() async {
        let result = await musicVideoImageRepository.fetchMusicVideoImage(with: artworkUrl100, trackID: trackID)
        switch result {
        case .success(let data):
            self.artworkImageData = data
            
        case .failure(let error):
            self.error.send(error.localizedDescription)
            
        }
    }
    
}

