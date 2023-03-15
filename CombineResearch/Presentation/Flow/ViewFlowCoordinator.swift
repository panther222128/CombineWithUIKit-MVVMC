//
//  ViewFlowCoordinator.swift
//  CombineResearch
//
//  Created by Horus on 2022/12/26.
//

import UIKit

protocol ViewFlowCoordinatorDependencies {
    func makeMusicVideoSearchViewController(action: MusicVideoSearchAction) -> MusicVideoSearchViewController
    func makeMusicVideoDetailViewController(musicVideo: MusicVideo) -> MusicVideoDetailViewController
}

final class ViewFlowCoordinator {
    
    private var navigationController: UINavigationController?
    private weak var tabBarController: UITabBarController?
    private let dependencies: ViewFlowCoordinatorDependencies
    
    private weak var musicVideoSearchViewController: MusicVideoSearchViewController?
    
    init(tabBarController: UITabBarController, dependencies: ViewFlowCoordinatorDependencies) {
        self.tabBarController = tabBarController
        self.dependencies = dependencies
    }
    
    func start() {
        tabBarController?.tabBar.tintColor = .black
        tabBarController?.tabBar.unselectedItemTintColor = .black
        
        let musicVideoSearchAction = MusicVideoSearchAction(showMusicVideoDetail: showMusicVideoDetail)
        
        self.musicVideoSearchViewController = dependencies.makeMusicVideoSearchViewController(action: musicVideoSearchAction)
        
        let musicVideoSearchViewControllerTabBarItem = UITabBarItem(title: "", image: Constants.TabBarImage.asset, tag: 0)
        
        guard let musicVideoSearchViewController = musicVideoSearchViewController else { return }
        musicVideoSearchViewController.tabBarItem = musicVideoSearchViewControllerTabBarItem
        
        if let selectedAsset = Constants.TabBarImage.selectedAsset {
            musicVideoSearchViewControllerTabBarItem.selectedImage = selectedAsset
        }
        
        navigationController = UINavigationController()
        guard let navigationController = navigationController else { return }
        
        self.tabBarController?.viewControllers = [navigationController]
        self.navigationController?.pushViewController(musicVideoSearchViewController, animated: true)
    }
    
    private func showMusicVideoDetail(musicVideo: MusicVideo) {
        let viewController = dependencies.makeMusicVideoDetailViewController(musicVideo: musicVideo)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
