//
//  MainViewModel.swift
//  CombineResearch
//
//  Created by Horus on 2022/12/26.
//

import Combine

protocol MusicVideosViewModel: MusicVideoDataSource {
    var error: PassthroughSubject<String, Never> { get }
    var musicVideos: CurrentValueSubject<MusicVideos, Error> { get }
    
    func didSearch(query: String)
    func didSelectItem(at index: Int)
}

struct MusicVideoSearchAction {
    let showMusicVideoDetail: (MusicVideo) -> Void
}

final class DefaultMusicVideosViewModel: MusicVideosViewModel {
    
    private var cancelBag: Set<AnyCancellable>
    private(set) var error: PassthroughSubject<String, Never>
    private(set) var musicVideos: CurrentValueSubject<MusicVideos, Error>
    
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
        load(musicVideoQuery: MusicVideoQuery(query: query))
    }
    
    func didSelectItem(at index: Int) {
        action.showMusicVideoDetail(musicVideos.value.results[index])
    }
    
}

// MARK: - Private

extension DefaultMusicVideosViewModel {
    
    private func load(musicVideoQuery: MusicVideoQuery) {
        do {
            try musicVideoSearchUseCase.execute(requestValue: SearchMusicVideoUseCaseRequestValue(query: musicVideoQuery, limit: limit, offset: offset, entity: entity))
                .sink(receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        return
                        
                    case .failure(let error):
                        self?.error.send("\(error)")
                        
                    }
                }, receiveValue: { [weak self] musicVideos in
                    if musicVideos.resultCount == 0 || musicVideos.results.isEmpty {
                        self?.error.send(Constants.Message.empty)
                    } else {
                        self?.musicVideos.value = musicVideos
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
