//
//  ViewFlowCoordinator.swift
//  CombineResearch
//
//  Created by Horus on 2022/12/26.
//

import UIKit

protocol ViewFlowCoordinatorDependencies {
    func makeTabBarController() -> UITabBarController
    func makeMusicVideoSearchViewController(action: MusicVideoSearchAction) -> MusicVideoSearchViewController
    func makeMusicVideoDetailViewController(musicVideo: MusicVideo) -> MusicVideoDetailViewController
}

final class ViewFlowCoordinator {
    
    private weak var navigationController: UINavigationController?
    private weak var tabBarController: UITabBarController?
    private let dependencies: ViewFlowCoordinatorDependencies
    
    private weak var mainViewController: MusicVideoSearchViewController?
    
    init(navigationController: UINavigationController, dependencies: ViewFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let tabBarController = dependencies.makeTabBarController()
        self.tabBarController = tabBarController
        self.tabBarController?.tabBar.tintColor = .black
        self.tabBarController?.tabBar.unselectedItemTintColor = .black
        
        let mainViewModelAction = MusicVideoSearchAction(showMusicVideoDetail: showMusicVideoDetail)
        
        let mainViewController = dependencies.makeMusicVideoSearchViewController(action: mainViewModelAction)
        self.mainViewController = mainViewController
        
        let mainTabBarItem = UITabBarItem(title: "", image: Constants.TabBarImage.asset, tag: 0)
        
        mainViewController.tabBarItem = mainTabBarItem
        
        if let selectedAsset = Constants.TabBarImage.selectedAsset {
            mainTabBarItem.selectedImage = selectedAsset
        }
        
        self.tabBarController?.viewControllers = [mainViewController]
        self.navigationController?.pushViewController(tabBarController, animated: true)
    }
    
    private func showMusicVideoDetail(musicVideo: MusicVideo) {
        let viewController = dependencies.makeMusicVideoDetailViewController(musicVideo: musicVideo)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
