//
//  AppFlowCoordinator.swift
//  CombineResearch
//
//  Created by Horus on 2022/12/26.
//

import UIKit

final class AppFlowCoordinator {

    private let tabBarController: UITabBarController
    private let appDIContainer: AppDIContainer
    
    init(tabBarController: UITabBarController, appDIContainer: AppDIContainer) {
        self.tabBarController = tabBarController
        self.appDIContainer = appDIContainer
    }
    
    func start() {
        let sceneDIContainer = appDIContainer.makeSceneDIContainer()
        let flow = sceneDIContainer.makeViewFlowCoordinator(tabBarController: tabBarController)
        flow.start()
    }
    
}
