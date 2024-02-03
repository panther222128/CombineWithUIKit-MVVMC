//
//  MainViewModel.swift
//  CombineResearch
//
//  Created by Horus on 2022/12/26.
//

import Combine
import Foundation

protocol MusicVideosViewModel: MusicVideoDataSource {
    var errorPublisher: AnyPublisher<String, Never> { get }
    var musicVideosPublisher: AnyPublisher<MusicVideos, Never> { get }
    
    func didSearch(query: String)
    func didSearchAsync(query: String) async
    func didSelectItem(at index: Int)
}

struct MusicVideoSearchAction {
    let showMusicVideoDetail: (MusicVideo) -> Void
}

final class DefaultMusicVideosViewModel: MusicVideosViewModel {
    
    private var cancelBag: Set<AnyCancellable>
    private var musicVideos: MusicVideos
    private var error: PassthroughSubject<String, Never>
    private var musicVideosSubject: CurrentValueSubject<MusicVideos, Never>
    
    var errorPublisher: AnyPublisher<String, Never> {
        return error.eraseToAnyPublisher()
    }
    var musicVideosPublisher: AnyPublisher<MusicVideos, Never> {
        return musicVideosSubject.eraseToAnyPublisher()
    }
    
    private let limit: Int
    private let offset: Int
    private let entity: String
    private let musicVideoSearchUseCase: MusicVideoSearchUseCase
    private let musicVideoImageRepository: MusicVideoImageRepository
    private let action: MusicVideoSearchAction
    
    init(limit: Int = 20, offset: Int = 0, entity: String = "musicVideo", musicVideoSearchUseCase: MusicVideoSearchUseCase, musicVideoImageRepository: MusicVideoImageRepository, action: MusicVideoSearchAction) {
        self.musicVideos = .init(resultCount: 0, results: [])
        self.limit = limit
        self.offset = offset
        self.entity = entity
        self.cancelBag = Set([])
        self.error = PassthroughSubject()
        self.musicVideosSubject = CurrentValueSubject<MusicVideos, Never>(MusicVideos(resultCount: 0, results: []))
        self.musicVideoImageRepository = musicVideoImageRepository
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
    
    func didSearchAsync(query: String) async {
        guard !query.isEmpty else { return }
        await load(musicVideoQuery: MusicVideoQuery(query: query))
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
                        self?.error.send(error.localizedDescription)
                        
                    }
                }, receiveValue: { [weak self] musicVideos in
                    if musicVideos.resultCount == 0 || musicVideos.results.isEmpty {
                        self?.error.send(Constants.Message.empty)
                    } else {
                        self?.musicVideos = musicVideos
                        guard let musicVideos = self?.musicVideos else {
                            self?.musicVideos = .init(resultCount: 0, results: [])
                            self?.musicVideosSubject.send(.init(resultCount: 0, results: []))
                            return
                        }
                        self?.musicVideosSubject.send(musicVideos)
                    }
                })
                .store(in: &self.cancelBag)
        } catch let error {
            self.error.send(error.localizedDescription)
        }
    }
    
    private func load(musicVideoQuery: MusicVideoQuery) async {
        do {
            let result = try await musicVideoSearchUseCase.execute(requestValue: SearchMusicVideoUseCaseRequestValue(query: musicVideoQuery, limit: limit, offset: offset, entity: entity))
            switch result {
            case .success(let musicVideos):
                self.musicVideos = musicVideos
                self.musicVideosSubject.send(self.musicVideos)
                
            case .failure(let error):
                self.error.send(error.localizedDescription)
                
            }
        } catch let error {
            self.error.send(error.localizedDescription)
        }
    }
    
    private func loadArtworkImage(at indexPath: IndexPath) async -> Result<Data, Error> {
        let musicVideo = musicVideos.results[indexPath.row]
        let result = await musicVideoImageRepository.fetchMusicVideoImage(with: musicVideo.artworkUrl100, trackID: musicVideo.trackID)
        switch result {
        case .success(let data):
            let success: Result<Data, Error> = .success(data)
            return success
            
        case .failure(let error):
            let failure: Result<Data, Error> = .failure(error)
            return failure
            
        }
    }
    
    private func loadArtworkImage(at indexPath: IndexPath, completion: @escaping (Result<Data?, Error>) -> Void) {
        let musicVideo = musicVideos.results[indexPath.row]
        musicVideoImageRepository.fetchMusicVideoImage(with: musicVideo.artworkUrl100, trackID: musicVideo.trackID, completion: completion)
    }
    
}

extension DefaultMusicVideosViewModel: MusicVideoDataSource {
    
    func numberOfMusicVideos() -> Int {
        return musicVideos.resultCount
    }
    
    func loadMusicVideo(at indexPath: IndexPath) async -> MusicVideoItemViewModel {
        let result = await loadArtworkImage(at: indexPath)
        
        switch result {
        case .success(let data):
            return .init(musicVideo: musicVideos.results[indexPath.row], artworkImageData: data)
            
        case .failure(_):
            return .init(musicVideo: musicVideos.results[indexPath.row], artworkImageData: Data())
            
        }
    }
    
    func loadMusicVideo(at indexPath: IndexPath, completion: @escaping (Result<MusicVideoItemViewModel, Error>) -> Void) {
        loadArtworkImage(at: indexPath) { [weak self] result in
            switch result {
            case .success(let data):
                guard let musicVideos = self?.musicVideos else { return }
                completion(.success(.init(musicVideo: musicVideos.results[indexPath.row], artworkImageData: data ?? Data())))
                
            case .failure(let error):
                completion(.failure(error))
                
            }
        }
    }
    
}
