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
    
    private weak var mainViewController: MusicVideoSearchViewController?
    
    init(tabBarController: UITabBarController, dependencies: ViewFlowCoordinatorDependencies) {
        self.tabBarController = tabBarController
        self.dependencies = dependencies
    }
    
    func start() {
        tabBarController?.tabBar.tintColor = .black
        tabBarController?.tabBar.unselectedItemTintColor = .black
        
        let mainViewModelAction = MusicVideoSearchAction(showMusicVideoDetail: showMusicVideoDetail)
        
        self.mainViewController = dependencies.makeMusicVideoSearchViewController(action: mainViewModelAction)
        
        let mainTabBarItem = UITabBarItem(title: "", image: Constants.TabBarImage.asset, tag: 0)
        
        guard let mainViewController = mainViewController else { return }
        mainViewController.tabBarItem = mainTabBarItem
        
        if let selectedAsset = Constants.TabBarImage.selectedAsset {
            mainTabBarItem.selectedImage = selectedAsset
        }
        
        navigationController = UINavigationController()
        guard let navigationController = navigationController else { return }
        
        self.tabBarController?.viewControllers = [navigationController]
        self.navigationController?.pushViewController(mainViewController, animated: true)
    }
    
    private func showMusicVideoDetail(musicVideo: MusicVideo) {
        let viewController = dependencies.makeMusicVideoDetailViewController(musicVideo: musicVideo)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
