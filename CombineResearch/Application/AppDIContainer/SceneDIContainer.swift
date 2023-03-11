//
//  SceneDIContainer.swift
//  CombineResearch
//
//  Created by Horus on 2022/12/26.
//

import UIKit

final class SceneDIContainer: ViewFlowCoordinatorDependencies {
 
    struct Dependencies {
        let apiDataTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func makeViewFlowCoordinator(tabBarController: UITabBarController) -> ViewFlowCoordinator {
        return ViewFlowCoordinator(tabBarController: tabBarController, dependencies: self)
    }
    
    func makeMusicVideosRepository() -> MusicVideoSearchRepository {
        return DefaultMusicVideoSearchRepository(dataTransferService: dependencies.apiDataTransferService)
    }
    
    func makeMusicVideoSearchUseCase() -> MusicVideoSearchUseCase {
        return DefaultMusicVideoSearchUseCase(musicVideoSearchRepository: makeMusicVideosRepository())
    }
    
    func makeMusicVideosViewModel(action: MusicVideoSearchAction) -> MusicVideosViewModel {
        return DefaultMusicVideosViewModel(musicVideoSearchUseCase: makeMusicVideoSearchUseCase(), action: action)
    }
    
    func makeMusicVideoSearchViewController(action: MusicVideoSearchAction) -> MusicVideoSearchViewController {
        return MusicVideoSearchViewController.create(with: makeMusicVideosViewModel(action: action))
    }
    
    func makeMusicVideoDetailViewModel(musicVideo: MusicVideo) -> MusicVideoDetailViewModel {
        return DefaultMusicVideoDetailViewModel(musicVideo: musicVideo)
    }
    
    func makeMusicVideoDetailViewController(musicVideo: MusicVideo) -> MusicVideoDetailViewController {
        return MusicVideoDetailViewController.create(with: makeMusicVideoDetailViewModel(musicVideo: musicVideo))
    }
    
}
