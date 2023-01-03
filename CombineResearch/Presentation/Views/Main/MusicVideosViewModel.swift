//
//  MainViewModel.swift
//  CombineResearch
//
//  Created by Horus on 2022/12/26.
//

import Foundation
import Combine

protocol MusicVideosViewModel: MusicVideoDataSource {
    var error: PassthroughSubject<String, Never> { get }
    var musicVideos: CurrentValueSubject<MusicVideos, Error> { get }
    
    func didSearch(query: String)
}

struct MusicVideoSearchAction {
    
}

final class DefaultMusicVideosViewModel: MusicVideosViewModel {
    
    var cancelBag: Set<AnyCancellable>
    var error: PassthroughSubject<String, Never>
    var musicVideos: CurrentValueSubject<MusicVideos, Error>
    
    private let limit: Int
    private let offset: Int
    private let entity: String
    private let musicVideoSearchUseCase: MusicVideoSearchUseCase
    private let action: MusicVideoSearchAction
    
    init(limit: Int = 20, offset: Int = 0, entity: String = "musicVideo", musicVideoSearchUseCase: MusicVideoSearchUseCase, action: MusicVideoSearchAction) {
        self.limit = limit
        self.offset = offset
        self.entity = entity
        self.cancelBag = Set([])
        self.error = PassthroughSubject()
        self.musicVideos = CurrentValueSubject<MusicVideos, Error>(MusicVideos(resultCount: 0, results: []))
        self.musicVideoSearchUseCase = musicVideoSearchUseCase
        self.action = action
    }
    
    func didSearch(query: String) {
        guard !query.isEmpty else { return }
        update(MusicVideoQuery(query: query))
    }
    
}

// MARK: - Private

extension DefaultMusicVideosViewModel {
    
    private func resetMusicVideo() {
        musicVideos = CurrentValueSubject<MusicVideos, Error>(MusicVideos(resultCount: 0, results: []))
    }
    
    private func update(_ musicVideoQuery: MusicVideoQuery) {
        resetMusicVideo()
        load(musicVideoQuery: musicVideoQuery)
    }
    
    private func load(musicVideoQuery: MusicVideoQuery) {
        do {
            try musicVideoSearchUseCase.execute(requestValue: SearchMusicVideoUseCaseRequestValue(query: musicVideoQuery, limit: limit, offset: offset, entity: entity))
                .sink(receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        return
                        
                    case .failure(let error):
                        self?.error.send(error.localizedDescription)
                        
                    }
                }, receiveValue: { [weak self] musicVideos in
                    if musicVideos.resultCount == 0 && musicVideos.results.isEmpty {
                        self?.error.send(Constants.Message.empty)
                    } else {
                        self?.musicVideos.send(musicVideos)
                    }
                })
                .store(in: &self.cancelBag)
        } catch {
            self.error.send(Constants.Message.loadError)
        }
    }
    
}

extension DefaultMusicVideosViewModel: MusicVideoDataSource {
    
    func numberOfMusicVideos() -> Int {
        return musicVideos.value.resultCount
    }
    
    func loadMusicVideo(at index: Int) -> MusicVideoCell.ViewModel {
        let musicVideo = musicVideos.value.results[index]
        return MusicVideoCell.ViewModel(artist: musicVideo.artistName, videoTitle: musicVideo.trackName, videoLength: musicVideo.trackTimeMillis ?? 0)
    }
    
}