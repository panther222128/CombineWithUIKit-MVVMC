//
//  MainViewModel.swift
//  CombineResearch
//
//  Created by Horus on 2022/12/26.
//

import Combine

enum MusicVideosError: Error {
    case isEmpty
    case loadError
}

protocol MusicVideosViewModel: MusicVideoDataSource {
    var error: PassthroughSubject<Error, Never> { get }
    var items: CurrentValueSubject<[MusicVideoItemViewModel], Error> { get }
    
    func didSearch(query: String)
    func didSelectItem(at index: Int)
}

struct MusicVideoSearchAction {
    let showMusicVideoDetail: (MusicVideo) -> Void
}

final class DefaultMusicVideosViewModel: MusicVideosViewModel {
    
    private var musicVideos: MusicVideos = .init(resultCount: 0, results: [])
    private var cancelBag: Set<AnyCancellable>
    private(set) var error: PassthroughSubject<Error, Never>
    private(set) var items: CurrentValueSubject<[MusicVideoItemViewModel], Error>
    
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
        self.items = CurrentValueSubject<[MusicVideoItemViewModel], Error>([])
        self.musicVideoSearchUseCase = musicVideoSearchUseCase
        self.action = action
    }
    
    func didSearch(query: String) {
        guard !query.isEmpty else { return }
        load(musicVideoQuery: MusicVideoQuery(query: query))
    }
    
    func didSelectItem(at index: Int) {
        action.showMusicVideoDetail(musicVideos.results[index])
    }
    
}

// MARK: - Private

extension DefaultMusicVideosViewModel {
    
    private func load(_ musicVideos: MusicVideos) {
        self.musicVideos = musicVideos
        items.value = self.musicVideos.results.map { MusicVideoItemViewModel(musicVideo: $0) }
    }
    
    private func load(musicVideoQuery: MusicVideoQuery) {
        do {
            try musicVideoSearchUseCase.execute(requestValue: SearchMusicVideoUseCaseRequestValue(query: musicVideoQuery, limit: limit, offset: offset, entity: entity))
                .sink(receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        return
                        
                    case .failure(let error):
                        self?.error.send(error)
                        
                    }
                }, receiveValue: { [weak self] musicVideos in
                    if musicVideos.resultCount == 0 || musicVideos.results.isEmpty {
                        self?.error.send(MusicVideosError.isEmpty)
                    } else {
                        self?.load(musicVideos)
                    }
                })
                .store(in: &self.cancelBag)
        } catch {
            self.error.send(MusicVideosError.loadError)
        }
    }
    
}

extension DefaultMusicVideosViewModel: MusicVideoDataSource {
    
    func numberOfMusicVideos() -> Int {
        return items.value.count
    }
    
    func loadMusicVideo(at index: Int) -> MusicVideoItemViewModel {
        return items.value[index]
    }
    
}
