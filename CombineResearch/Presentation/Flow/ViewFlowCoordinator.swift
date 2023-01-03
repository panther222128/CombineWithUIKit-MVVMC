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
        
        let mainViewModelAction = MusicVideoSearchAction()
        
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
    
}
