//
//  MainViewModel.swift
//  CombineResearch
//
//  Created by Horus on 2022/12/26.
//

import Foundation
import Combine

protocol MusicVideosViewModel: MusicVideoDataSource {
    var musicVideos: CurrentValueSubject<MusicVideos, Error> { get }
    
    func didSearch(query: String)
}

struct MusicVideoSearchAction {
    
}

final class DefaultMusicVideosViewModel: MusicVideosViewModel {
    
    var cancelBag: Set<AnyCancellable>
    var musicVideos: CurrentValueSubject<MusicVideos, Error>
    
    private let limit: Int
    private let offset: Int
    private let musicVideoSearchUseCase: MusicVideoSearchUseCase
    private let action: MusicVideoSearchAction
    
    init(limit: Int = 20, offset: Int = 0, musicVideoSearchUseCase: MusicVideoSearchUseCase, action: MusicVideoSearchAction) {
        self.limit = limit
        self.offset = offset
        self.cancelBag = Set([])
        self.musicVideos = CurrentValueSubject<MusicVideos, Error>(MusicVideos(resultCount: 0, results: []))
        self.musicVideoSearchUseCase = musicVideoSearchUseCase
        self.action = action
    }
    
    func didSearch(query: String) {
        guard !query.isEmpty else { return }
        update(MusicVideoQuery(query: query))
    }
    
    private func resetMusicVideo() {
        musicVideos = CurrentValueSubject<MusicVideos, Error>(MusicVideos(resultCount: 0, results: []))
    }
    
    private func update(_ musicVideoQuery: MusicVideoQuery) {
        resetMusicVideo()
        load(musicVideoQuery: musicVideoQuery)
    }
    
    private func load(musicVideoQuery: MusicVideoQuery) {
        do {
            try musicVideoSearchUseCase.execute(requestValue: SearchMusicVideoUseCaseRequestValue(query: musicVideoQuery, limit: limit, offset: 0, entity: "musicVideo"))
                .sink(receiveCompletion: { completion in
                    print(completion)
                }, receiveValue: { [weak self] response in
                    self?.musicVideos.send(response)
                })
                .store(in: &self.cancelBag)
        } catch {
            
        }
    }
    
}

extension DefaultMusicVideosViewModel: MusicVideoDataSource {
    
    func numberOfMusicVideos() -> Int {
        return musicVideos.value.resultCount
    }
    
    func loadMusicVideo(at index: Int) -> MusicVideoCell.ViewModel {
        let musicVideo = musicVideos.value.results[index]
        return MusicVideoCell.ViewModel(artist: musicVideo.artistName, videoTitle: musicVideo.trackName, videoLength: musicVideo.trackTimeMillis)
    }
    
}
